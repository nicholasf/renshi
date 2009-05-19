module Renshi
  class Frameworks
    def self.register
      rails() if defined? ENV['RAILS_ENV']
    end
    
    def self.rails
      if defined? ActionView::TemplateHandler
        ActionView::Template.register_template_handler(:ren, Renshi::Plugin)        
      end
    end
  end

  if defined? ActionView::TemplateHandler
    class Plugin < ActionView::TemplateHandler
      def self.call(template)
        "#{name}.new(self).render(template, local_assigns)"
      end

      def initialize(view = nil)
        @view = view
      end

      def render(template, local_assigns)        
        out = Renshi::Parser.parse(template.source, @view.renshi_binding)
        return out
      end
    end
  end
end


  # include ActionView::TemplateHandlers::Compilable
#           
#   def compile(template)
#     if template.respond_to? :source
#       source = template.source
#     else
#       source = template
#     end
#     
#     # debugger
#     out = Renshi::Parser.parse(source, binding)
#     return out
#   end
# end
