require 'renshi/attribute_expressions/if'
require 'renshi/attribute_expressions/elsif'
require 'renshi/attribute_expressions/else'
require 'renshi/attribute_expressions/while'
require 'renshi/attribute_expressions/for'

module Renshi
  module AttributeExpressions
    
    def encode_xml_entities(expression)
      expression.gsub!("<", Renshi::Parser::XML_LT)
      expression.gsub!(">", Renshi::Parser::XML_GT)
      expression.gsub!("&", Renshi::Parser::XML_AMP)
      return expression
    end
  end
end