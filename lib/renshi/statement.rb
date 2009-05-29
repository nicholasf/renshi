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
    
    def compile!
      str = "#{Renshi::Parser::STRING_END};#{self.str};#{Renshi::Parser::STRING_START}"
    end

    def compile_to_print!
      str = "#{Renshi::Parser::STRING_END}@output_buffer.concat(#{self.str});#{Renshi::Parser::STRING_START}"
    end
  end
end