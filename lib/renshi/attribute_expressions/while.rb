module Renshi
  module AttributeExpressions
    class While      
      def evaluate(expression, node)        
        node.open_clause("while (#{expression})")
        node.close_clause("end")
      end
    end
  end
end