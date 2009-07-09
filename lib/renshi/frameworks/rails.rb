module Renshi
  module Frameworks
    module Rails
      if defined? ActionView::TemplateHandler        
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
      end
    end
  end
end

