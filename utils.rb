require 'yaml'
require 'stringio'

module Utils

  def self.change_file_extension_to_html(filename)
    filename[-2..-1] = "html"
    filename
  end
