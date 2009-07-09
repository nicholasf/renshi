module Renshi
  module AttributeExpressions
    class While
      def evaluate(expression, node)
        node.open_clause("while (#{expression})")
        node.close_clause("end")
        node.remove_attribute("r:while")
      end
    end
  end
end