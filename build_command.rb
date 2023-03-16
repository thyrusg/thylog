require 'kramdown'
require 'stringio'
require 'tmpdir'
require 'yaml'

#TODO: Pull out the generate_all, generate_collection, generate_single methods into their own subclasses

module BuildCommand

  def self.call
    setup
    generate_index
    generate_collection_posts
    generate_collection_notes
    generate_all_posts
    generate_all_notes
    puts "Files Here: #{@directory}"
  end

  def self.cleanup
    FileUtils.remove_entry(@directory)
  end

  def self.generate_all_posts
    input_posts = Dir.children("./input/posts")
    input_posts.each do |post|
      generate_single_post(post)
    end
  end

  def self.generate_all_notes
    input_notes = Dir.children("./input/notes")
    input_notes.each do |note|
      generate_single_note(note)
    end
  end

  def self.generate_index
    source_index_file = "./input/index.md"
    dest_index_file = "#{@directory}/index.html"
    yaml, file_content = extract_yaml_and_contents(source_index_file)
    output = Kramdown::Document.new(file_content).to_html
    File.write(dest_index_file, output)
  end

  def self.generate_single_post(post_path)
    source_post_file = post_path
    file_name = File.basename(post_path)
    dest_post_file = change_file_extension_to_html("#{@posts}/#{file_name}")
    yaml, file_content = extract_yaml_and_contents(source_post_file)

    output = Kramdown::Document.new(file_content).to_html
    File.write(dest_post_file, output)
  end

  def self.generate_collection_posts
    posts_directory = "./input/posts"
    files = Dir.children(posts_directory)
    io = StringIO.new
    files.each do |file|
      metadata, file_content = extract_yaml_and_contents(file)
      title = metadata["title"]
      io.puts "<a href=/post/#{file}> #{title} </a>"
    end
    puts io.string
  end

  def self.generate_single_note(note_path)
    source_note_file = note_path
    file_name = File.basename(note_path)
    dest_note_file = change_file_extension_to_html("#{@notes}/#{file_name}")
    yaml, file_content = extract_yaml_and_contents(source_note_file)

    output = Kramdown::Document.new(file_content).to_html
    File.write(dest_note_file, output)
  end

  def self.generate_collection_notes
    notes_directory = "./input/notes"
    files = Dir.children(notes_directory)
    io = StringIO.new
    files.each do |file|
      metadata, file_content = extract_yaml_and_contents(file)
      title = metadata["title"]
      io.puts "<a href=/post/#{file}> #{title} </a>"
    end
    puts io.string
  end

  private

  def self.setup
    if @directory.nil?
      create_directory_structure
    end
  end

  def self.create_directory_structure
    puts "Creating temporary directory structure"
    @directory = Dir.mktmpdir("thylog")
    @posts, @notes = generate_tmp_structure
  end

  def self.generate_tmp_structure
    ["#{@directory}/posts", "#{@directory}/notes"].each {|dir| FileUtils.mkdir(dir) }
  end

  def self.change_file_extension_to_html(path)
    path[-2..-1] = "html"
    path
  end

  def self.extract_yaml_and_contents(file_path)
    yaml_string = StringIO.new
    file = File.open(file_path, "r")
    until $_ == ""
      yaml_string.puts(file.gets(chomp: true))
    end
    content = file.read
    file.close
    return YAML.safe_load(yaml_string.string), content
  end
end
