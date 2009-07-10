module Renshi
  module AttributeExpressions
    class For
      
      def evaluate(expression, node)
        node.open_clause("for #{expression}")
        node.close_clause("end")
      end
    end
  end
end