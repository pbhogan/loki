module Loki
  module Task
    class Task < Base
      include Identity
      attr_reader :children


      def initialize(name)
        @children = []
        super(name)
      end


      def task(name, &block)
        add_dependency Task.new(name), &block
      end


      def proc(&block)
        source = Loki.block_unique_id(&block)
        add_dependency Proc.new(source, &block)
      end


      def make(result_pattern, source_pattern = nil, &block)
        if source_pattern.nil?
          add_dependency Make.new(result_pattern), &block
        else
          source_pattern = FilePattern.new(source_pattern)
          result_pattern = FilePattern.new(result_pattern)
          if result_pattern.individual?
            add_dependency Make.new(result_pattern, source_pattern.to_a), &block
          else
            source_pattern.interpolate_each(result_pattern) do |source_path, result_path|
              add_dependency Make.new(result_path, source_path), &block
            end
          end
        end
      end


      def scan(dependencies, &block)
        dependencies = Dir.glob(dependencies) if dependencies.is_a?(String)
        dependencies.each do |dependency|
          add_dependency(File.new(dependency), &block)
        end
      end


      def work
        super do
          @children.each do |task|
            task.work unless task.done?
          end
        end
      end


      def done?
        @children.reject(&:sham?).all?(&:done?)
      end


      def time
        @children.collect(&:time).max || super
      end


      def list
        super do
          @children.each do |task|
            task.list
          end
        end
      end


      protected

      def add_dependency(task, &block)
        unless children.include?(task)
          task.parent = self
          children << task
          task.evaluate(&block) if block_given?
        end
        task
      end

    end # class
  end # module
end # module
