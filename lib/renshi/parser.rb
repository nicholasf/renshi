require 'renshi/statement'

module Renshi
  # The Renshi parser tries to respect speed without complexity. It builds a set of instructions within
  # the document, which are finally compiled into Ruby.
  
  class Parser
    STRING_END = "^R_END" #maybe replace this with a funky unicode char
    STRING_START = "^R_START" #maybe replace this with a funky unicode char
    BUFFER_CONCAT_OPEN = "@output_buffer.concat(\""
    BUFFER_CONCAT_CLOSE = "\");"
    NEW_LINE = "@output_buffer.concat('\n');"
    INSTRUCTION_START = "^R_INSTR_IDX_START^"
    INSTRUCTION_END = "^R_INSTR_IDX_END^"
    
    #these symbols cannot be normally escaped, as we need to differentiate between &lt; as an
    #escaped string, to be left in the document, and < as a boolean operator
    XML_LT = "^R_LT^"
    XML_GT = "^R_GT^"
    XML_AMP = "^R_AMP^"
    
    def self.parse(xhtml)
      if xhtml.index("<head>") #better way to detect the full HTML document structure?
        doc = Nokogiri::HTML::Document.parse(xhtml)
      else
        doc = Nokogiri::HTML.fragment(xhtml)
      end
      
      parser = self.new(doc)
      out = parser.parse
      
      return out
    end
    
    def initialize(nokogiri_node)
      @doc = nokogiri_node
      @instructions = []
      @instr_idx = 0
    end
    
    def parse
      @doc.children.each do |node|
       transform_node(node)
      end      

      inner_html = @doc.inner_html
      compiled = compile_to_buffer(inner_html) if inner_html
       # puts "\n", compiled, "\n"
      return compiled
    end

    def transform_node(node)
      if node.attributes
        expressions = node.commands
        for expression in expressions 
          AttributeExpressions.perform_expression(node, expression)
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
        if compiled
          @instructions << compiled
          key = "#{INSTRUCTION_START}#{@instr_idx}#{INSTRUCTION_END}"
          @instr_idx = @instr_idx + 1
          # node.content = compiled if compiled
          node.content = key
        end
      end

      node.children.each {|child| transform_node(child)}
    end
 

    def compile(text)
      idx = text.index("$")
      return text if idx.nil?
      
      bits = []
      bits << text[0..(idx -1)] if idx != 0
      
      while idx != nil do
        next_char = text[(idx + 1)..(idx + 1)]
    
        if next_char == " "          
          raise SyntaxError, "Floating $ - use $$ to output '$': #{text[(idx +1)..-1]}", caller
        elsif next_char == "(" 
          #this may be jquery, etc. $(...) 
          end_statement_idx = (idx + 2)
          bits << text[idx..(idx + 1)]    
        elsif next_char == "$"
          #an escaped $ - i.e. '$$'
          end_statement_idx = (idx + 2)
          bits << "$"
          
          #${...}
        elsif next_char == "{"
          begin
            #scan for the next $ in this block
            closing_brace_idx = close_of_phrase_ending_with("}", text, idx)
            statement_str = text[(idx + 2)..(closing_brace_idx -1)]
            statement = Renshi::Statement.new(statement_str)
            bits << statement.compile_to_print!
            end_statement_idx = closing_brace_idx + 1
          rescue StandardError
            raise SyntaxError, "No closing brace: #{text}", caller
          end
          
          #$[...]
        elsif next_char == "["
          begin
            # closing_brace_idx = text.rindex("]")
            closing_brace_idx = close_of_phrase_ending_with("]", text, idx)
            statement_str = text[(idx + 2)..(closing_brace_idx -1)]
            statement = Renshi::Statement.new(statement_str)
            bits << statement.compile_to_expression!
            end_statement_idx = closing_brace_idx + 1
          rescue StandardError
            raise SyntaxError, "No closing bracket: #{text}", caller
          end          
        else #$foo
          
          #divide with a delimiter for anything which is not a name character - alpa-numeric and underscore
          words = text[(idx +1)..-1].split(/[^\w."'{}()+=*\/\-]/)
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

    
    def close_of_phrase_ending_with(char, text, idx)
      phrase_end = (text[(idx + 1)..-1].index("$")) 
      
      if phrase_end.nil?
        phrase_end = text.length 
      else
        phrase_end = phrase_end + idx
      end
      closing_brace_idx = text[idx...phrase_end].rindex(char) + idx
      return closing_brace_idx
    end
    
    def compile_to_buffer(str)
      compiled = "@output_buffer ='';" << BUFFER_CONCAT_OPEN      
      str = compile_print_flags(str)    
      compiled = "#{compiled}#{str}" << BUFFER_CONCAT_CLOSE
    end
    
    def compile_print_flags(str)
      #now we parse for RENSHI::STRING_END and RENSHI::STRING_START
      #and ensure natural strings are buffered
      str.gsub!("\"", "\\\"")
      str.gsub!(XML_GT, ">")
      str.gsub!(XML_LT, "<")
      str.gsub!(XML_AMP, "&")
      
      #restore instructions in the string      
      bits = []
      str.split(INSTRUCTION_START).each do |bit|
        instr_end = bit.index(INSTRUCTION_END)
        if instr_end
          index = bit[0...instr_end] 
          instruction = @instructions[index.to_i]
          
          bit.gsub!("#{index}#{INSTRUCTION_END}", instruction)
        end
        
        bits << bit
      end
      
      str = bits.join
      
      str.gsub!(STRING_END, BUFFER_CONCAT_CLOSE)
      str.gsub!(STRING_START, BUFFER_CONCAT_OPEN)

      return str
    end
  end
end