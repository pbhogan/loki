module Loki
  module Task
    class Make < Task

      def initialize(result_pattern, source_pattern = nil, &block)
        @source_pattern = FilePattern.new(source_pattern)
        @result_pattern = FilePattern.new(result_pattern)
        @block = block
        @expanded = false
        super(source_pattern.to_s + " => " + result_pattern.to_s)
        @children = nil
      end


      def children
        @children ||= expand_patterns
      end


      private

      def expand_patterns
        @children = []
        if @source_pattern.nil?
          if @result_pattern.individual?
            add_dependency(File.new(@result_pattern.to_s), &@block)
          else
            raise "result must specify a single file if no source pattern specified"
          end
        else
          if @result_pattern.individual?
            add_dependency(File.new(@result_pattern, @source_pattern.to_a), &@block)
          else
            @source_pattern.interpolate_each(@result_pattern) do |source_path, result_path|
              add_dependency(File.new(result_path, source_path), &@block)
            end
          end
        end
        @children
      end

    end # class
  end # module
end # module
