require 'kramdown'
require 'stringio'

module BuildCommand

  def self.call
    setup
    generate_index
    generate_collection_posts
    generate_collection_notes
    generate_all_posts
    generate_all_notes
  end

  def self.generate_all_posts
  end

  def self.generate_all_notes
  end

  def self.generate_index
    source_index_file = "./input/index.md"
    dest_index_file = "#{@directory}/index.html"
    output = Kramdown::Document.new(File.read(source_index_file)).to_html
    File.write(dest_index_file, output)
  end

  def self.generate_single_post(post_path)
    source_post_file = post_path
    file_name = File.basename(post_path)
    dest_post_file = change_file_extension_to_html("#{@posts}/#{file_name}")

    output = Kramdown::Document.new(File.read(source_post_file)).to_html
    File.write(dest_post_file, output)
  end

  def generate_collection_posts
    # the collection post will just be a single HTML page
    # that has a list of links to all of the other posts
    # so we need a template that iterates over a collection of 
    # posts and turns them into links
    posts_directory = "./input/posts"
    files = Dir.children(posts_directory)
    io = StringIO.new
    files.each do |file|
      metadata = YAML.load_file("#{posts_directory}/#{file}")
      title = metadata["title"]
      io.puts "<a href=/post/#{file}> #{title} </a>"
    end
    puts io.string
  end

  def self.generate_single_note(note_path)
    source_note_file = note_path
    file_name = File.basename(note_path)
    dest_note_file = change_file_extension_to_html("#{@notes}/#{file_name}")

    output = Kramdown::Document.new(File.read(source_note_file)).to_html
    File.write(dest_note_file, output)
  end

  def self.generate_collection_notes
    notes_directory = "./input/notes"
    files = Dir.children(notes_directory)
    io = StringIO.new
    files.each do |file|
      metadata = YAML.load_file("#{notes_directory}/#{file}")
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

end
