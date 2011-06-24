module Loki
  class FilePattern
    include Enumerable
    attr_reader :path


    def initialize(path)
      self.path = path
    end


    def path=(new_path)
      @path = new_path.to_s
    end


    def each(&block)
      Dir.glob(@path).each do |file|
        yield FilePath.new(file) if block_given?
      end
    end
    
    
    def interpolate_each(result_pattern, &block)
      each do |source_path|
        yield source_path, interpolate(source_path, result_pattern) if block_given?
      end
    end


    def individual?
      !(@path =~ /[\?\[\]\{\}\*]/)
    end


    def collection?
      !individual?
    end


    def relative(from = Dir.pwd)
      @path.gsub(/^#{from}\//, '')
    end


    def absolute
      ::File.expand_path(@path)
    end


    def to_s
      @path.to_s
    end
    
    
    private

    def interpolate(source_path, result_pattern)
      parts_regex = ""
      parts = absolute.split("/") # File::SEPARATOR
      parts.each_with_index do |part, index|
        if part == "**"
          parts_regex += "((?:[^\/]+\/)*)"
        else
          has_captures = !!(part =~ /[\?\[\]\{\}\*]/)
          part.gsub!(/\?/, ".")
          part.gsub!(/([\.\\])/, "\\\\\\1")
          part.gsub!(/\{([^\}]+)\}/) { "(?:" + $1.split(",").join("|") + ")" }
          part.gsub!(/\*/, "[^\/]+")
          parts_regex += has_captures ? "(" + part + ")" : part
          parts_regex += "/" unless index == parts.size - 1
        end
      end
      parts = source_path.to_s.match(/^#{parts_regex}$/)
      result_pattern.to_s.gsub(/\*+\/?/).each_with_index { |m, i| parts[i+1] }
    end

  end # class
end # module