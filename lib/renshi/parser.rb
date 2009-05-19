module Renshi
  class Parser
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
        node.content = node.interpret(context)
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
  end
end