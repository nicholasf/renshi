require 'renshi/attribute_expressions/if'
require 'renshi/attribute_expressions/elsif'
require 'renshi/attribute_expressions/else'
require 'renshi/attribute_expressions/while'
require 'renshi/attribute_expressions/for'

module Renshi
  module AttributeExpressions
    
    def self.perform_expression(node, command)
      expression = command[0][2..-1]
      
      obj = nil
      begin
        obj = eval "Renshi::AttributeExpressions::#{expression.capitalize}.new"
      rescue StandardError 
        raise Renshi::SyntaxError, "Could not find attribute expression called #{expression}.rb", caller
      end
      
      expression = encode_xml_entities(command[1].to_s)
      obj.evaluate(expression, node)
    end
    
    def self.encode_xml_entities(expression)
      expression.gsub!("<", Renshi::Parser::XML_LT)
      expression.gsub!(">", Renshi::Parser::XML_GT)
      expression.gsub!("&", Renshi::Parser::XML_AMP)
      return expression
    end
  end
end