$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

# Renshi's aim is to be a lightweight library with dependencies solely on 
# nokogiri.
#
# The Renshi parser tries to respect speed without complexity. It takes the 
# approach that transformations should be done as they are encountered (much 
# like a SAXParser) rather than preparing a tree of transformations.
  
require 'nokogiri'
require 'renshi/parser'
require 'renshi/conditional_expressions'

module Renshi
  VERSION="0.0.1"
    
  class RenshiError < StandardError; end
  
  class Statement
    attr_accessor :str
    attr_accessor :context
    attr_accessor :interpreted_string
    
    def initialize(str, context)
      @str = str
      @context = context
    end
    
    def interpret!
      @interpreted_string = eval self.str, self.context
    end    
  end

  #helper methods for Renshi on the Nokogiri XMLNode
  module Node
    def commands
      commands = []
      for key in self.keys
        commands << [key, self.attributes[key]] if key[0..1] == "r:"
      end
      return commands
    end
    
    def interpret(context) 
      idx = self.text.index("$")
      return self.text if idx.nil?
      
      bits = []
      bits << self.text[0..(idx -1)] if idx != 0
      while idx != nil do
        if self.text[(idx + 1)..(idx + 1)] == "{"
          begin
            closing_brace_idx = self.text().index("}")
            statement_str = self.text[(idx + 2)..(closing_brace_idx -1)]
            statement = Renshi::Statement.new(statement_str, context)
            bits << statement.interpret!
            end_statement_idx = closing_brace_idx + 1
          rescue StandardError => boom
            raise RenshiError, "No closing brace: #{self.text()[(idx +1)..-1]}", caller
          end
        else #$foo
          words = self.text()[(idx +1)..-1].split(/\s/)
          statement_str = words.first
          statement = Statement.new(statement_str, context)
          bits << statement.interpret!
          end_statement_idx = (words.first.length) + 1 + idx
        end

        next_statement_idx = self.text().index("$", end_statement_idx)
                
        if next_statement_idx
          gap = self.text()[end_statement_idx..(next_statement_idx -1)]
          bits << gap
        else
          bits << self.text()[end_statement_idx..-1]
        end
        idx = next_statement_idx
      end       
      
      return bits.join
    end
  end
end

Nokogiri::XML::Node.send(:include, Renshi::Node)
