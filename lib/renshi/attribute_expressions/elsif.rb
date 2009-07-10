module Renshi
  module AttributeExpressions
    class Elsif      
      def evaluate(expression, node)
        node.open_clause("elsif (#{expression})")
  
        sibling = node.next_real
        
        if sibling
          sibling_commands = sibling.commands
        
          if sibling_commands.first
            expression = sibling_commands.first[0][2..-1]
            if expression == "else"
              return
            end
          end
        end
        
        node.close_clause("end")
      end
    end
  end
end