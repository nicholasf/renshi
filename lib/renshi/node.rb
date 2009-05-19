require 'renshi/statement'
module Renshi
  #helper methods for Renshi on the Nokogiri XMLNode
  module Node
    def commands
      commands = []
      for key in self.keys
        commands << [key, self.attributes[key]] if key[0..1] == "r:"
      end
      return commands
    end
    
    def interpret(context) 
      idx = self.text.index("$")
      return self.text if idx.nil?
      
      bits = []
      bits << self.text[0..(idx -1)] if idx != 0
      while idx != nil do
        if self.text[(idx + 1)..(idx + 1)] == "{"
          begin
            closing_brace_idx = self.text().index("}")
            statement_str = self.text[(idx + 2)..(closing_brace_idx -1)]
            statement = Renshi::Statement.new(statement_str, context)
            bits << statement.interpret!
            end_statement_idx = closing_brace_idx + 1
          rescue StandardError => boom
            raise SyntaxError, "No closing brace: #{self.text()[(idx +1)..-1]}: #{boom.to_s}", caller
          end
        else #$foo
          words = self.text()[(idx +1)..-1].split(/\s/)
          statement_str = words.first
          statement = Statement.new(statement_str, context)
          bits << statement.interpret!
          end_statement_idx = (words.first.length) + 1 + idx
        end

        next_statement_idx = self.text().index("$", end_statement_idx)
                
        if next_statement_idx
          gap = self.text()[end_statement_idx..(next_statement_idx -1)]
          bits << gap
        else
          bits << self.text()[end_statement_idx..-1]
        end
        idx = next_statement_idx
      end       
      
      return bits.join
    end
  end
end