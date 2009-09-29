module Sinatra
  module Templates
    def ren(template, options={}, locals={})
      render :ren, template, options, locals
    end
  
    private
    def render_ren(template, data, options, locals, &block)
      out = Renshi::Parser.parse(data)
      return eval(out, binding)
    end            
  end
end
