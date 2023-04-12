#!/usr/bin/env ruby
ACCEPTED_COMMANDS = ["add", "build", "output"]
valid_add_subcommands = ["note", "post"]

ACCEPTED_COMMANDS.each { |command| require_relative "./#{command}_command.rb" }

command = ARGV[0]
subcommand = ARGV[1]
file_path = ARGV[2]

puts "Arguments: #{ARGV}"
if command.nil?
  puts "No command supplied. Please use #{ACCEPTED_COMMANDS.join(', ')}"
  exit 1
end

def verify_command(command)
  puts "Please use a valid command: #{ACCEPTED_COMMANDS.join(', ')}"; exit 1 unless ACCEPTED_COMMANDS.include? command
end

case command
when "add"
  if valid_add_subcommands.include?(subcommand) && File.exists?(file_path)
    add_command = AddCommand.new(type: subcommand, path_to_file: file_path)
    add_command.call
  else
    puts "Invalid subcommand for add or file does not exist"
    exit 1
  end
when "build"
  BuildCommand.call
when "output"
  OutputCommand.call(directory: subcommand)
end
