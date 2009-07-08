module Renshi
  module ConditionalExpressions
    class Elsif
      def evaluate(expression, node)
        node.open_clause("elsif (#{expression})")
  
        sibling = node.next_real
        
        if sibling
          sibling_commands = sibling.commands
        
          if sibling_commands.first
            expression = sibling_commands.first[0][2..-1]
            if expression == "else"
              node.remove_attribute("r:elsif")
              return
            end
          end
        end
        
        node.close_clause("end")
        node.remove_attribute("r:elsif")
      end
    end
  end
end