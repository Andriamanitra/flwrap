require "option_parser"

require "./flwrap.cr"

completions = [] of String

parser = OptionParser.new do |parser|
  parser.banner = "Usage: flwrap [arguments] command"
  parser.on("-f COMPLETIONS", "Specify a file to read completions from") do |fname|
    completions = File.read_lines(fname)
  end
  parser.on("-h", "--help", "Show this help") do
    puts parser
    exit
  end
end

parser.parse

if ARGV.empty?
  puts parser
  exit
else
  cmd = ARGV[0]
  args = ARGV[1..]
  wproc = Flwrap::WrappedProc.new(cmd, args, completions)
  wproc.run
end
