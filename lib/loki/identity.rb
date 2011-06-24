module Loki

  IDENTITY_MAP = {}

  module Identity
    def self.included(other)
      other.class_eval %{
        class << self
          alias_method :__#{other.to_s.gsub(':','')}_new, :new
          def new(name, *args, &block)
            name = self.identify(name) if self.respond_to?(:identify)
            IDENTITY_MAP.fetch(name) do
              IDENTITY_MAP[name] = __#{other.to_s.gsub(':','')}_new(name, *args, &block)
            end
          end
        end
      }
    end
  end

end # module