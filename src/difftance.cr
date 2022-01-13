require "./difftance/*"
require "option_parser"

module Difftance
  VERSION = "0.1.0"
end


args = [] of String
no_sub = false
operation_cost = { :deletion => 1, :insertion => 1, :substitution => 1 }

parser = OptionParser.parse do |parser|
  parser.banner = "Usage: difftance [options] FILE1 FILE2"
  parser.on("-h", "--help", "Show this help") do
    puts parser
    exit
  end
  parser.on("--no-substitution", "Disable substitution(fast, allow only deletion and insertion)") do
    no_sub = true
  end

  parser.on("--cost-ins=COST", "Specify the cost of insertion, default: 1") do |cost|
    operation_cost[:insertion] = cost.to_i
  end

  parser.on("--cost-del=COST", "Specify the cost of deletion, default: 1") do |cost|
    operation_cost[:deletion] = cost.to_i
  end

  parser.on("--cost-sub=COST", "Specify the cost of substitution, default: 1") do |cost|
    operation_cost[:substitution] = cost.to_i
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


if no_sub
  operation_cost[:substitution] = operation_cost[:insertion] + operation_cost[:deletion]
end

if args.size == 7 && ENV.has_key?("GIT_DIFF_PATH_COUNTER")
  path, old_file, old_hex, old_mode, new_file, new_hex, new_mode = args
  old_content = File.read(File.expand_path(old_file))
  new_content = File.read(File.expand_path(new_file))

  distance = Difftance::EditDistance.edit_distance(old_content, new_content, operation_cost)
  puts "#{path}: #{distance}"
elsif args.size == 1 && ENV.has_key?("GIT_DIFF_PATH_COUNTER")
  path = args[0]
  puts "#{path}: #{File.read(File.expand_path(path)).size}"
elsif args.size == 2
  if File.info(args[0]).directory? && File.info(args[1]).directory?
    # Directory diff
    Difftance::DirectoryDiff.exec(args[0], args[1], operation_cost)
  else
    content1 = File.read(args[0])
    content2 = File.read(args[1])
    distance = Difftance::EditDistance.edit_distance(content1, content2, operation_cost)
    # When executed by `git difftool --extcmd=difftance`, use $BASE as a path in output
    path_output = ENV.has_key?("BASE") ? ENV["BASE"] : "#{args[0]}, #{args[1]}"
    puts "#{path_output}: #{distance}"
  end
else
  STDERR.puts "Error: Invalid arguments"
  STDERR.puts parser
  exit 1
end
