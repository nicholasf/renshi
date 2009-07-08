module Renshi
  module ConditionalExpressions
    class If
      def evaluate(expression, node)
        node.open_clause("if (#{expression})")
  
        sibling = node.next_real
        
        if sibling
          sibling_commands = sibling.commands
        
          if sibling_commands.first
            expression = sibling_commands.first[0][2..-1]
            if expression == "else" or expression == "elsif"
              node.remove_attribute("r:if")
              return
            end
          end
        end
        
        node.close_clause("end")
        node.remove_attribute("r:if")
      end
    end
  end
end