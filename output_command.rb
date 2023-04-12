require_relative './build_command'

module OutputCommand

  def self.call(directory:)
    if directory.nil?
      puts "Please pass a directory path for the output files"
      exit 1
    end
    BuildCommand.call(File.realpath(directory))
  end
end
