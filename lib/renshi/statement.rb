module Renshi
  class Statement
    attr_accessor :str
  
    def initialize(str)
      @str = str
    end
      
    def compile!
      str = "#{Renshi::Parser::STRING_END}#{self.str};#{Renshi::Parser::STRING_START}"
    end

    def compile_to_print!
      str = "#{Renshi::Parser::STRING_END}@output_buffer.concat(#{self.str});#{Renshi::Parser::STRING_START}"
    end
  end
end