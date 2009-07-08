require 'renshi/statement'

module Renshi
  # The Renshi parser tries to respect speed without complexity. It builds a set of instructions within
  # the document, which are then compiled into Ruby. 
  
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
      
      obj = nil
      begin
        obj = eval "Renshi::ConditionalExpressions::#{expression.capitalize}.new"
      rescue StandardError 
        raise Renshi::SyntaxError, "Could not find conditional expression called #{expression}", caller
      end
      
      obj.evaluate(command[1], node)
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