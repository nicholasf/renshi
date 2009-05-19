module Renshi
  class Frameworks
    def self.register
      debugger
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
      include ActionView::TemplateHandlers::Compilable if defined?(ActionView::TemplateHandlers::Compilable)

      def compile(template)
        # if template.respond_to? :source
        #   options[:filename] = template.filename
        #   source = template.source
        # else
        #   source = template
        # end

        # Haml::Engine.new(source, options).send(:precompiled_with_ambles, [])
        debugger
        # Renshi::Parser.parse(sou)
      end
    end
  end
end
