require "./difftance/*"
require "option_parser"

module Difftance
  VERSION = "0.1.0"
end


args = [] of String

OptionParser.parse do |parser|
  parser.banner = "Usage: difftance [options] FILE1 FILE2"
  parser.on("-h", "--help", "Show this help") do
    puts parser
    exit
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
