module Loki
  module Task
    class Make < File
      include Identity


      def initialize(path, sources = nil)
        @sources = Array(sources).map { |s| File.new(s) }
        super(path)
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


      def up_to_date?
        (@children + @sources).none? { |task| task.time > time }
      end
      
      def test?
        @children.find_all { |task| task.time > time }.each do |o|
          ap "#{o.name} #{o.time}"
        end
        (@children + @sources).reject(&:sham?).none? { |task| task.time > time }
      end

    end # class
  end # module
end # module
