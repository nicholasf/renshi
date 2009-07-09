require 'renshi/statement'

module Renshi
  # The Renshi parser tries to respect speed without complexity. It builds a set of instructions within
  # the document, which are finally compiled into Ruby.
  
  class Parser
    STRING_END = "R_END" #maybe replace this with a funky unicode char
    STRING_START = "R_START" #maybe replace this with a funky unicode char
    BUFFER_CONCAT_OPEN = "@output_buffer.concat(\""
    BUFFER_CONCAT_CLOSE = "\");"
    NEW_LINE = "@output_buffer.concat('\n');"
    
    #these symbols cannot be normally escaped, as we need to differentiate between &lt; as an
    #escaped string, to be left in the document, and < as a boolean operator
    XML_LT = "R_LT"
    XML_GT = "R_GT"
    XML_AMP = "R_AMP"
    
    def self.parse(xhtml)
      doc = Nokogiri::HTML.fragment(xhtml)

      doc.children.each do |node|
       transform_node(node)
      end      
      
      inner_html = doc.inner_html
      compiled = compile_to_buffer(inner_html) if inner_html
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
      
      #compile text in attribute values, e.g. <div id="foo$i>"
      if node.attributes()
        for attribute in node.attributes()
          compiled = compile(attribute[1].to_s)
          if compiled
            node[attribute[0]]= (compiled) 
          end
        end        
      end
      
      #compile text in nodes, e.g. <p>*</p>
      if node.text?
        compiled = compile(node.text)
        node.content = compiled if compiled
      end

      node.children.each {|child| transform_node(child)}
    end

    def self.perform_expression(node, command)
      expression = command[0][2..-1]
      
      obj = nil
      begin
        obj = eval "Renshi::AttributeExpressions::#{expression.capitalize}.new"
      rescue StandardError 
        raise Renshi::SyntaxError, "Could not find attribute expression called #{expression}.rb", caller
      end
      
      obj.evaluate(command[1].to_s, node)
    end
    
    def self.compile(text)
      idx = text.index("$")
      return text if idx.nil?
      
      bits = []
      bits << text[0..(idx -1)] if idx != 0
      while idx != nil do
        if text[(idx + 1)..(idx + 1)] == "("
          #this may be jquery, etc. $(...)
          return text
        elsif text[(idx + 1)..(idx + 1)] == "{"
          begin
            closing_brace_idx = text.rindex("}")
            statement_str = text[(idx + 2)..(closing_brace_idx -1)]
            statement = Renshi::Statement.new(statement_str)
            bits << statement.compile_to_print!
            end_statement_idx = closing_brace_idx + 1
          rescue Renshi::StandardError
            raise SyntaxError, "No closing brace: #{text[(idx +1)..-1]}", caller
          end
        elsif text[(idx + 1)..(idx + 1)] == "["
          begin
            closing_brace_idx = text.rindex("]")
            statement_str = text[(idx + 2)..(closing_brace_idx -1)]
            statement = Renshi::Statement.new(statement_str)
            bits << statement.compile_to_expression!
            end_statement_idx = closing_brace_idx + 1
          rescue Renshi::StandardError
            raise SyntaxError, "No closing bracket: #{text[(idx +1)..-1]}", caller
          end          
        else #$foo
          words = text[(idx +1)..-1].split(/\s/)
          words[0] = "'$'" if words[0] == "$"
          statement_str = words.first
          statement = Statement.new(statement_str)
          bits << statement.compile_to_print!
          end_statement_idx = (words.first.length) + 1 + idx
        end

        next_statement_idx = text.index("$", end_statement_idx)
                
        if next_statement_idx
          gap = text[end_statement_idx..(next_statement_idx -1)]
          bits << gap
        else
          bits << text[end_statement_idx..-1]
        end
        idx = next_statement_idx
      end       
      
      return bits.join
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
      str.gsub!(XML_GT, ">")
      str.gsub!(XML_LT, "<")
      str.gsub!(XML_AMP, "&")
      
      return str
    end
  end
end