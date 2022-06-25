require "option_parser"

require "./flwrap.cr"
require "./rewrite_rules.cr"


completions = [] of String
rewrite_rules = RewriteRules.new
prompt = ">> "

parser = OptionParser.new do |parser|
  parser.banner = "Usage: flwrap [arguments] command"
  parser.on("-f COMPLETIONS", "Specify a file to read completions from") do |fname|
    completions = File.read_lines(fname)
  end
  parser.on("-r REWRITES", "Specify a file to read rewrite rules from") do |fname|
    rewrite_rules = RewriteRules.from_file(fname)
  end
  parser.on("-p PROMPT", "Choose a prompt") do |prmpt|
    prompt = prmpt
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
  wproc = Flwrap::WrappedProc.new(
    cmd,
    args: args,
    completions: completions,
    rewrite_rules: rewrite_rules,
    prompt: prompt
  )
  wproc.run
end
