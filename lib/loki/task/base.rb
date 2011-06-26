module Loki
  module Task
    class Base
      attr_reader :name


      def initialize(name)
        @name = name
        @parent = nil
      end


      def work(&block)
        Loki.logger.puts "#{@name}" if Loki.logger.indented?
        Loki.logger.push
        yield if block_given?
        Loki.logger.pull
      end


      def time
        Time.now
      end


      def done?
        false
      end


      def sham?
        false
      end


      def list(&block)
        Loki.logger.line
        Loki.logger.puts "#{self.class}: #{@name}, done: #{done?}, time: #{time}", "-"
        Loki.logger.push
        yield if block_given?
        Loki.logger.pull
        Loki.logger.line
      end


      protected

      def parent
        @parent
      end


      def parent=(parent)
        @parent = parent
      end


      def siblings
        @parent.children.reject { |child| child.equal?(self) }
      end


      def siblings_prior
        @parent.children.take_while { |child| !child.equal?(self) }
      end


      def evaluate(&block)
        block_id = Loki.block_unique_id(&block)
        @evaluated ||= {}
        unless @evaluated.has_key?(block_id)
          instance_eval(&block)
          @evaluated[block_id] = true
        end
      end

    end # class
  end # module
end # module