require 'yaml'
require 'stringio'

module Utils

  def self.change_file_extension_to_html(filename)
    filename[-2..-1] = "html"
    filename
  end

  def self.extract_yaml_and_contents(path_to_file)
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
