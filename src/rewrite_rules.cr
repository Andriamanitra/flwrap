alias Rule = Tuple(Regex, String)

class RewriteRules
  def initialize(@rules : Array(Rule) = [] of Rule)
  end

  def apply(str)
    @rules.each do |patt, res|
      if patt.matches?(str)
        return str.sub(patt, res)
      end
    end
    str
  end

  def self.from_file(fname)
    lines = File.read_lines(fname)
    rules = lines.map { |line|
      patt, _, res = line.partition(" ---> ")
      { Regex.new(patt), res }
    }
    self.new(rules)
  end
end
