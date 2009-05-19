module Renshi
  class Statement
    attr_accessor :str
    attr_accessor :context
    attr_accessor :interpreted_string
  
    def initialize(str, context)
      @str = str
      @context = context
    end
  
    def interpret!
      @interpreted_string = eval self.str, self.context
    end    
  end
end