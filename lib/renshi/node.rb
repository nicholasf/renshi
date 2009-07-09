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