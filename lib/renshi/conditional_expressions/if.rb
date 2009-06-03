module Renshi
  module ConditionalExpressions
    class If
      def evaluate(expression, node)
        node.open_clause("if #{expression}")
        node.close_clause("end")
      end
    end
  end
end