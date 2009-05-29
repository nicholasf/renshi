require 'renshi/statement'

module Renshi
  # The Renshi parser tries to respect speed without complexity. It takes the 
  # approach that transformations should be done as they are encountered (much 
  # like a SAXParser) rather than preparing a tree of transformations.
  
  class Parser
    STRING_END = "R_END" #maybe replace this with a funky unicode char
    STRING_START = "R_START" #maybe replace this with a funky unicode char
    BUFFER_CONCAT_OPEN = "@output_buffer.concat(\""
    BUFFER_CONCAT_CLOSE = "\");"
    
    def self.parse(xhtml)
      compiled = "@output_buffer ='';" << BUFFER_CONCAT_OPEN
      doc = Nokogiri::HTML.fragment(xhtml)

      doc.children.each do |node|
       transform_node(node, compiled)
      end
      
      #now we parse for RENSHI::STRING_END and RENSHI::STRING_START
      #and ensure natural strings are buffered
      out = doc.inner_html
      out.gsub!("\"", "\\\"")
      out.gsub!(STRING_END, BUFFER_CONCAT_CLOSE)
      out.gsub!(STRING_START, BUFFER_CONCAT_OPEN)
      
      compiled = "#{compiled}#{out}" << BUFFER_CONCAT_CLOSE
      
      return compiled
    end

    def self.transform_node(node, compiled)
      if node.attributes
        expressions = node.commands
        for expression in expressions 
          perform_expression(node, compiled, expression)
        end
      end

      if node.text?
        node.content = node.interpret(compiled)
      end

      node.children.each {|child| transform_node(child, compiled)}
    end

    def self.perform_expression(node, compiled, command)
      expression = command[0][2..-1]
      begin
        obj = eval "Renshi::ConditionalExpressions::#{expression.capitalize}.new"
        obj.evaluate(compiled, command[1], node)

      rescue StandardError => boom
        raise SyntaxError "No conditional expression called #{expression}", boom
      end
    end
  end
end