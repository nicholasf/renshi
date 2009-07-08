module Renshi
  class Statement
    attr_accessor :stmt
  
    def initialize(str)
      @stmt = str
    end
      
    def compile_to_expression!
      str = "#{Renshi::Parser::STRING_END}#{self.stmt};#{Renshi::Parser::STRING_START}"
    end

    def compile_to_print!
      str = "#{Renshi::Parser::STRING_END}@output_buffer.concat((#{self.stmt}).to_s);#{Renshi::Parser::STRING_START}"
    end
  end
end