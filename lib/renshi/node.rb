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
    
    def interpret 
      idx = self.text.index("$")
      return self.text if idx.nil?
      
      bits = []
      bits << self.text[0..(idx -1)] if idx != 0
      while idx != nil do
        if self.text[(idx + 1)..(idx + 1)] == "{"
          begin
            closing_brace_idx = self.text().rindex("}")
            statement_str = self.text[(idx + 2)..(closing_brace_idx -1)]
            statement = Renshi::Statement.new(statement_str)
            bits << statement.compile_to_print!
            end_statement_idx = closing_brace_idx + 1
          rescue Renshi::StandardError
            raise SyntaxError, "No closing brace: #{self.text()[(idx +1)..-1]}", caller
          end
        elsif self.text[(idx + 1)..(idx + 1)] == "["
          begin
            closing_brace_idx = self.text().rindex("]")
            statement_str = self.text[(idx + 2)..(closing_brace_idx -1)]
            statement = Renshi::Statement.new(statement_str)
            bits << statement.compile_to_expression!
            end_statement_idx = closing_brace_idx + 1
          rescue Renshi::StandardError
            raise SyntaxError, "No closing bracket: #{self.text()[(idx +1)..-1]}", caller
          end          
        else #$foo
          words = self.text()[(idx +1)..-1].split(/\s/)
          words[0] = "'$'" if words[0] == "$"
          statement_str = words.first
          statement = Statement.new(statement_str)
          bits << statement.compile_to_print!
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
    
    #opens a clause on an element, for example an if statement on a div
    def open_clause(opening)
      self.before("#{Renshi::Parser::STRING_END} #{opening}; #{Renshi::Parser::STRING_START}")
    end
    
    #typically an end statement
    def close_clause(closing)
      self.after("#{Renshi::Parser::STRING_END} #{closing}; #{Renshi::Parser::STRING_START}")
    end
    
    #just a hack on next, as Nokogiri returns a new line as the next sibling.
    def next_real
      sibling = self.next
      
      while sibling and sibling.text.strip == ""
        sibling = sibling.next
      end
      
      return sibling
    end
  end
end