module Renshi
  module AttributeExpressions
    class Else
      
      def evaluate(expression, node)
        node.open_clause("else")
        node.close_clause("end")
      end
    end
  end
end