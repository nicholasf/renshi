module Renshi
  module AttributeExpressions
    class Else
      def evaluate(expression, node)
        node.open_clause("else")
        node.close_clause("end")
        node.remove_attribute("r:else")
      end
    end
  end
end