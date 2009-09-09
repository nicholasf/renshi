module Renshi
  module Frameworks    
    #framework integrations can be loaded within notice by checking the environment
    def self.notice
      require 'renshi/frameworks/rails' if defined? ENV['RAILS_ENV']
      require 'renshi/frameworks/sinatra' if defined? Sinatra
    end    
  end
end

