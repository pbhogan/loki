module Loki
  class Logger
    include Singleton
    

    COLORS = {
      :red     => 31,
      :green   => 32,
      :yellow  => 33,
      :blue    => 34,
      :magenta => 35,
      :cyan    => 36,
      :white   => 37,
      :r       => 31,
      :g       => 32,
      :y       => 33,
      :b       => 34,
      :m       => 35,
      :c       => 36,
      :w       => 37
    }


    def initialize
      @indent = 0
    end


    def push
      @indent += 1
    end


    def pull
      @indent -= 1
    end


    def puts(text, mark = ">")
      $stdout.puts((" " * @indent * 2) + "#{mark} #{parse(text)}")
    end


    def line
      $stdout.puts("-" * 80) if @indent == 0
    end
    
    
    public
    
    def paint(text, color = :white)
      "\e[#{COLORS[color]}m#{text}\e[0m"
    end


    def parse(text)
      colors = COLORS.keys.collect(&:to_s).join('|')
      text.gsub(/\<(#{colors})\>(.*)\<\/\1\>/) do
        paint($2, $1.to_sym)
      end
    end

  end # class


  def self.logger
    @logger ||= Logger.instance
  end

end # module