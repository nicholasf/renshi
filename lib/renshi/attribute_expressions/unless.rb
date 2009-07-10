module Renshi
  module AttributeExpressions
    class Unless      
      def evaluate(expression, node)
        node.open_clause("unless (#{expression})")
  
        sibling = node.next_real
        
        if sibling
          sibling_commands = sibling.commands
        
          if sibling_commands.first
            expression = sibling_commands.first[0][2..-1]
            if expression == "else" or expression == "elsif"
              return
            end
          end
        end
        
        node.close_clause("end")
      end
    end
  end
end