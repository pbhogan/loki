require 'singleton'


module Loki
  class Primeval
    include Comparable
    include Singleton


    def <=>(other)
      -1
    end


    def to_s
      "<Primeval>"
    end


    def strftime(*args)
      "<Primeval>"
    end
  end


  PRIMEVAL = Primeval.instance
end


class Time

  alias loki_original_compare :<=>
  def <=>(other)
    if Loki::Primeval === other
      - other.<=>(self)
    else
      loki_original_compare(other)
    end
  end


  def to_s
    strftime("%m-%d-%Y %H:%M:%S")
  end

end