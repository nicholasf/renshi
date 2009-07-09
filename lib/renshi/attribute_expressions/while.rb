module Renshi
  module AttributeExpressions
    class While
      include Renshi::AttributeExpressions
      
      def evaluate(expression, node)
        expression = encode_xml_entities(expression)
        node.open_clause("while (#{expression})")
        node.close_clause("end")
        node.remove_attribute("r:while")
      end
    end
  end
end