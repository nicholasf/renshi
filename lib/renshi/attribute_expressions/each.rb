module Renshi
  module AttributeExpressions
    class Each      
      def evaluate(expression, node)        
        bits = expression.split(",")
        
        node.open_clause("#{bits[0]}.each do #{bits[1..-1].join(',')}")
        node.close_clause("end")
      end
    end
  end
end