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
        add_dependency Make.new(result_pattern, source_pattern, &block)
      end


      def scan(dependencies, &block)
        dependencies = Dir.glob(dependencies) if dependencies.is_a?(String)
        dependencies.each do |dependency|
          add_dependency(File.new(dependency), &block)
        end
      end


      def work
        super do
          children.each do |task|
            task.work unless task.done?
          end
        end
      end


      def done?
        children.reject(&:sham?).all?(&:done?)
      end


      def time
        children.collect(&:time).max || super
      end


      def list
        super do
          children.each do |task|
            task.list
          end
        end
      end


      protected

      def add_dependency(task, &block)
        unless children.include?(task)
          task.parent = self
          @children << task
          task.evaluate(&block) if block_given?
        end
        task
      end

    end # class
  end # module
end # module
