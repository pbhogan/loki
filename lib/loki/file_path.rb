module Loki
  class FilePath
    attr_reader :path


    def initialize(path)
      self.path = path
    end


    def path=(path)
      @path = ::File.expand_path(path.to_s)
    end


    def relative(from = Dir.pwd)
      @path.gsub(/^#{from}\//, '')
    end


    def absolute
      ::File.expand_path(@path)
    end


    def mtime
      ::File.mtime(@path)
    end


    def exists?
      ::File.exists?(@path)
    end


    def to_s
      @path.to_s
    end

  end # class
end # module