require 'nokogiri'

module Renshi
  
  def self.parse(xhtml, context)
    doc = Nokogiri::HTML(xhtml)
    
    #puts "before: \n #{doc}"
    
    doc.root.children.each do |node|
     transform_node(node, context)
    end
    
    #puts "after: \n #{doc}"
    return doc.to_s
  end
  
  def self.transform_node(node, context)
    if node.text?
      refs = node.text.split("$")

      if refs.size > 1
        refs.each do |ref|
          next if ref.empty?
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
end