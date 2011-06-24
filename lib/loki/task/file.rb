module Loki
  module Task
    class File < Task
      include Identity


      def initialize(path)
        @path = FilePath.new(path)
        super(@path.relative)
      end


      def self.identify(name)
        ::File.expand_path(name.to_s)
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
        @children.none? { |task| task.time > time }
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
