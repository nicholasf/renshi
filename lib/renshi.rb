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
      commands = node.commands
      for command in commands 
        execute_command(node, context, command)
      end
    end
    
    if node.text?
      refs = node.text.split("$")

      if refs.size > 1
        refs.each do |ref|
          next if ref.empty? or ref.strip.empty?
          words = ref.split(/(\s+)/)
          key_sym = words.first.to_sym
          val = context[key_sym]
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
  
  def self.execute_command(node, context, command)
    expression = command[0][2..-1]
    begin
      # debugger
      obj = eval "Renshi::ConditionalExpressions::#{expression.capitalize}.new"
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
