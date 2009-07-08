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
      doc = Nokogiri::HTML.fragment(xhtml)

      doc.children.each do |node|
       transform_node(node)
      end      
      
      compiled = compile_to_buffer(doc.inner_html)
      # puts "\n", compiled, "\n"
      return compiled
    end

    def self.transform_node(node)
      if node.attributes
        expressions = node.commands
        for expression in expressions 
          perform_expression(node, expression)
        end
      end

      if node.text?
        node.content = node.interpret()
      end

      node.children.each {|child| transform_node(child)}
    end

    def self.perform_expression(node, command)
      expression = command[0][2..-1]
      begin
        obj = eval "Renshi::ConditionalExpressions::#{expression.capitalize}.new"
        obj.evaluate(command[1], node)

      rescue StandardError => boom
        raise SyntaxError "No conditional expression called #{expression}", boom
      end
    end
    
    def self.compile_to_buffer(str)
      compiled = "@output_buffer ='';" << BUFFER_CONCAT_OPEN      
      str = compile_print_flags(str)    
      compiled = "#{compiled}#{str}" << BUFFER_CONCAT_CLOSE
    end
    
    def self.compile_print_flags(str)
      #now we parse for RENSHI::STRING_END and RENSHI::STRING_START
      #and ensure natural strings are buffered
      str.gsub!("\"", "\\\"")
      str.gsub!(STRING_END, BUFFER_CONCAT_CLOSE)
      str.gsub!(STRING_START, BUFFER_CONCAT_OPEN)
      return str
    end
  end
end