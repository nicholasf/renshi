class HelloController < ActionController::Base
  
  def index
    @foo = "yes"
  end
  
  def erb
    @foo = "yes"    
  end
  
  def haml
    @foo = "yes"    
  end
end
