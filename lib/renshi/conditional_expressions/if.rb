module Renshi
  module ConditionalExpressions
    class If
      def evaluate(expression, node)
        node.open_clause("if #{expression}")
        # before("#{Renshi::Parser::STRING_END} if #{expression}; #{Renshi::Parser::STRING_START}")
        node.close_clause("end")
        
        # after("#{Renshi::Parser::STRING_END} end; #{Renshi::Parser::STRING_START}")        
      end
    end
  end
end