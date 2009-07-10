module Renshi
  module Frameworks
    module Rails
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
        
        class CompilablePlugin
          include ActionView::TemplateHandlers::Compilable

          def compile(template)
            if template.respond_to? :source
              source = template.source
            else
              source = template
            end
            out = Renshi::Parser.parse(source)
            return out
          end
        end
      end

      if defined? ActionView::TemplateHandler
        ActionView::Template.register_template_handler(:ren, Renshi::Frameworks::Rails::CompilablePlugin)  

        class ActionView::Base
          def renshi_binding
            binding
          end
        end          
      end
    end
  end
end

