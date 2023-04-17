require 'kramdown'
require 'stringio'
require 'tmpdir'
require 'yaml'
require './input/all_posts'
require './input/all_notes'

#TODO: Pull out the generate_all, generate_collection, generate_single methods into their own classes and files

module BuildCommand

  Note = Struct.new('Note', :title, :contents, keyword_init: true)
  Post = Struct.new('Post', :title, :filename, keyword_init: true)

  def self.call(directory=nil)
    setup(directory)
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
    posts_directory = "./input/posts"
    input_posts = Dir.children(posts_directory)
    input_posts.each do |post|
      post = "#{posts_directory}/#{post}"
      generate_single_post(post)
    end
  end

  def self.generate_all_notes
    notes_directory = "./input/notes"
    input_notes = Dir.children(notes_directory)
    input_notes.each do |note|
      note = "#{notes_directory}/#{note}"
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
    posts = []
    files.each do |file|
      file = "#{posts_directory}/#{file}"
      metadata, file_content = extract_yaml_and_contents(file)
      posts << Post.new(title: metadata["title"], filename: file)
    end
    b = binding

    results = PostsHTMLGenerator.new(b).run
    File.write("#{@directory}/all-posts.html", results)

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
    notes = []
    files.each do |file|
      file = "#{notes_directory}/#{file}"
      metadata, file_content = extract_yaml_and_contents(file)
      title = metadata["title"]
      notes << Note.new(title: title, contents: file_content)
    end
    b = binding

    results = NotesHTMLGenerator.new(b).run
    File.write("#{@directory}/all-notes.html", results)
  end

  private

  def self.setup(directory=nil)
    if directory
      @directory = directory
      @posts = "#{@directory}/posts"
      @notes = "#{@directory}/notes"
      generate_tmp_structure
    else
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
