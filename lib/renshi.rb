$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))
  
require 'nokogiri'
require 'renshi/conditional_expressions'

module Renshi
  VERSION="0.0.1"
  
  def self.parse(xhtml, context)
    doc = Nokogiri::HTML(xhtml)
    
    # puts "before: \n #{doc}"

    doc.root.children.each do |node|
     transform_node(node, context)
    end
    
    # puts "after: \n #{doc}"
    return doc.to_s
  end
  
  def self.transform_node(node, context)
    
    if node.attributes
      expressions = node.commands
      for expression in expressions 
        perform_expression(node, context, expression)
      end
    end
    
    if node.text?
      refs = node.text.split("$")

      if refs.size > 1
        refs.each do |ref|
          next if ref.empty? or ref.strip.empty?
          
          # if ref[0] == "{"
          #   
          # end
          
          words = ref.split(/(\s+)/)
          val = eval words.first, context
          words[0] = val
          idx = refs.index(ref)
          refs[idx] = words.join
          ref = words.join
        end
      end
      
      node.content = refs.join
    end
    
    node.children.each {|child| transform_node(child, context)}
  end
  
  def self.perform_expression(node, context, command)
    expression = command[0][2..-1]
    begin
      obj = eval "Renshi::ConditionalExpressions::#{expression.capitalize}.new"
      obj.evaluate(context, command[1], node)
      
    rescue StandardError => boom
      raise RenshiError "No conditional expression called #{expression}", boom
    end
  end
  
  class RenshiError < StandardError; end  

  #helper methods for Renshi on the Nokogiri XMLNode
  module Node
    def commands
      commands = []
      for key in self.keys
        commands << [key, self.attributes[key]] if key[0..1] == "r:"
      end
      return commands
    end
  end
end

Nokogiri::XML::Node.send(:include, Renshi::Node)
