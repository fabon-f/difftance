require "./difftance"
require "option_parser"

def read_file(path : String)
  {% if flag?(:win32) %}
    return "" if path == "nul"
  {% end %}
  return "" if path == "/dev/null"
  Difftance::FileUtils.read_textfile(File.expand_path(path))
end

def directory?(path : String)
  {% if flag?(:win32) %}
    return false if path == "nul"
  {% end %}
  path == "/dev/null" ? false : File.info(path).directory?
end

def unsupported_binary
  STDERR.puts "Binary or unsupported encoding, skipped"
  exit 0
end

args = [] of String
no_sub = true
operation_cost = { :deletion => 1, :insertion => 1, :substitution => 1 }

ARGV.concat(ENV["DIFFTANCE_OPTS"].split) if ENV.has_key?("DIFFTANCE_OPTS")

parser = OptionParser.parse do |parser|
  parser.banner = "Usage: difftance [options] FILE1 FILE2"
  parser.on("-h", "--help", "Show this help") do
    puts parser
    exit
  end
  parser.on("-v", "--version", "Show the version of this program") do
    puts Difftance::VERSION
    exit
  end

  parser.on("--allow-substitution", "Allow substitution(Compute Levenshtein distance, slow and consume much memory)") do
    no_sub = false
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

if args.size == 7 && ENV.has_key?("GIT_DIFF_PATH_COUNTER")
  path, old_file, old_hex, old_mode, new_file, new_hex, new_mode = args
  old_content = read_file(old_file)
  new_content = read_file(new_file)

  if old_content.nil? || new_content.nil?
    unsupported_binary
  end

  distance = Difftance::EditDistance.edit_distance(old_content, new_content, operation_cost, no_sub)
  puts "#{path}: #{distance}"
elsif args.size == 1 && ENV.has_key?("GIT_DIFF_PATH_COUNTER")
  path = args[0]
  content = read_file(path)
  if content.nil?
    unsupported_binary
  end
  puts "#{path}: #{content.size * operation_cost[:insertion]}"
elsif args.size == 2
  if directory?(args[0]) && directory?(args[1])
    # Directory diff
    Difftance::DirectoryDiff.exec(args[0], args[1], operation_cost)
  else
    content1 = read_file(args[0])
    content2 = read_file(args[1])

    if content1.nil? || content2.nil?
      unsupported_binary
    end

    distance = Difftance::EditDistance.edit_distance(content1, content2, operation_cost, no_sub)
    # When executed by `git difftool --extcmd=difftance`, use $BASE as a path in output
    path_output = ENV.has_key?("BASE") ? ENV["BASE"] : "#{args[0]}, #{args[1]}"
    puts "#{path_output}: #{distance}"
  end
else
  STDERR.puts "Error: Invalid arguments"
  STDERR.puts parser
  exit 1
end
