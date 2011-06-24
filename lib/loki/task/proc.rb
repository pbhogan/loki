module Loki
  module Task
    class Proc < Base

      def initialize(name, &proc)
        @proc = proc
        super(name.gsub(/^#{Dir.pwd}\//, ''))
      end


      def work
        super do
          @proc.call unless @proc.nil?
        end
      end


      def time
        Loki::PRIMEVAL
      end


      def done?
        siblings.reject(&:sham?).all?(&:done?) and @parent.done?
      end


      def sham?
        true
      end

    end # class
  end # module
end # module
