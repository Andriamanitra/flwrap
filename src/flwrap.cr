# wrap arbitrary programs with fancyline
require "fancyline"

require "./rewrite_rules.cr"


module Flwrap
  VERSION = "0.1.0"

  class WrappedProc
    def initialize(
      @cmd : String,
      @args : Array(String) = [] of String,
      @completions : Array(String) = [] of String,
      @rewrite_rules : RewriteRules = RewriteRules.new,
      @prompt : String = "> ",
      @read_timeout : Float32 = 0.05
    )
      @fancy = Fancyline.new

      @fancy.autocomplete.add do |ctx, range, word, yielder|
        fl_completions = yielder.call(ctx, range, word)
        @completions.each do |s|
          if s.starts_with?(word)
            fl_completions << Fancyline::Completion.new(range, s)
          end
        end
        fl_completions
      end
    end

    def run()
      proc = Process.new(
        @cmd,
        args: @args,
        input: Process::Redirect::Pipe,
        error: Process::Redirect::Pipe,
        output: Process::Redirect::Pipe
      )

      proc.output.read_timeout = @read_timeout
      proc.error.read_timeout = @read_timeout
      read_output(proc)
      while input = @fancy.readline(@prompt)
        m_input = @rewrite_rules.apply(input)
        proc.input.puts(m_input)
        read_output(proc)
      end
    end
    
    private def try_read(io)
      io.gets
    rescue IO::TimeoutError
      return nil
    end

    private def read_output(proc)
      while got = try_read(proc.output)
        puts got
      end
      Colorize.reset
      while got = try_read(proc.error)
        puts got
      end
      Colorize.reset
    end
  end
end
