module Loki
  module Task
    class File < Task
      include Identity


      def initialize(path, sources = nil)
        @sources = Array(sources).map { |s| File.new(s) }
        @path = FilePath.new(path)
        super(@path.relative)
      end


      def self.identify(name)
        ::File.expand_path(name.to_s)
      end


      def sources
        @sources.collect(&:path)
      end


      def source_path
        @sources.first.path
      end


      def result_path
        @path.path
      end


      def path
        @path.path
      end


      def done?
        exists? and up_to_date? and super
      end


      def exists?
        @path.exists?
      end


      def up_to_date?
        (@children + @sources).none? { |task| task.time > time }
      end


      def time
        if exists?
          @path.mtime
        else
          Loki::PRIMEVAL
        end
      end

    end # class
  end # module
end # module
