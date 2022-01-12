require "./difftance/*"
require "option_parser"

module Difftance
  VERSION = "0.1.0"
end


args = [] of String
no_sub = false

parser = OptionParser.parse do |parser|
  parser.banner = "Usage: difftance [options] FILE1 FILE2"
  parser.on("-h", "--help", "Show this help") do
    puts parser
    exit
  end
  parser.on("--no-substitution", "Disable substitution(fast, allow only deletion and insertion)") do
    no_sub = true
  end

  parser.invalid_option do |flag|
    STDERR.puts "Error: #{flag} is not a valid option."
    STDERR.puts parser
    exit 1
  end

  parser.unknown_args do |unknown_args|
    args = unknown_args
  end
end

if args.size == 7 && ENV.has_key?("GIT_DIFF_PATH_COUNTER")
  path, old_file, old_hex, old_mode, new_file, new_hex, new_mode = args
  old_content = File.read(File.expand_path(old_file))
  new_content = File.read(File.expand_path(new_file))

  distance = no_sub ? Difftance::EditDistance.edit_distance_no_substitution(old_content, new_content) : Difftance::EditDistance.dp(old_content, new_content)
  puts "#{path}: #{distance}"
elsif args.size == 1 && ENV.has_key?("GIT_DIFF_PATH_COUNTER")
  path = args[0]
  puts "#{path}: #{File.read(File.expand_path(path)).size}"
elsif args.size == 2
  content1 = File.read(args[0])
  content2 = File.read(args[1])
  distance = no_sub ? Difftance::EditDistance.edit_distance_no_substitution(content1, content2) : Difftance::EditDistance.dp(content1, content2)
  puts "#{args[0]}, #{args[1]}: #{distance}"
else
  STDERR.puts "Error: Invalid arguments"
  STDERR.puts parser
  exit 1
end
