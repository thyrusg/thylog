class AddCommand

  require 'fileutils'
  INPUT_FOLDER = "./input"
  NOTES_FOLDER = "#{INPUT_FOLDER}/notes"
  POSTS_FOLDER = "#{INPUT_FOLDER}/posts"

  def initialize(type:, path_to_file:)
    @file = path_to_file
    @type = type
    verify_input_directories_exist
  end

  def call
    if @type == "post"
      add_post
    else
      add_note
    end
  end

  def add_post
    dest_file_path = "#{POSTS_FOLDER}/#{@file}"
    copy_file(@file, dest_file_path)
  end

  def add_note
    dest_file_path = "#{NOTES_FOLDER}/#{@file}"
    copy_file(@file, dest_file_path)
  end

  private

  def copy_file(src_file_path, dest_file_path)
    if File.exist?(file_path) and !(File.directory?(file_path))
      FileUtils.copy(file_path, dest_file_path)
    end
  end

  def verify_input_directories_exist
    exist = File.directory?(INPUT_FOLDER) &&
      File.directory?(NOTES_FOLDER) &&
      File.directory?(POSTS_FOLDER)
    if not exist
      puts "Missing directory structure. Please run the following:"
      puts "mkdir -p ./input/notes && mkdir -p ./input/posts"
      exit 1
    end
  end
end
