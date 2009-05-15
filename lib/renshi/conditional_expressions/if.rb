module Renshi
  module ConditionalExpressions
    class If
      def evaluate(context, expression, node)
        result = eval expression, context
        
        unless result
          node.unlink
        end
      end
    end
  end
end