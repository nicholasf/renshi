module Renshi
  module ConditionalExpressions
    class If
      def evaluate(context, expression, node)
        node.before("#{Renshi::Parser::STRING_END} if #{expression}; #{Renshi::Parser::STRING_START}")
        node.after("#{Renshi::Parser::STRING_END} end; #{Renshi::Parser::STRING_START}")        
      end
    end
  end
end