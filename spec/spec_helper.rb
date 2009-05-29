require 'rubygems'
require 'spec'
require 'ruby-debug'
require File.expand_path(File.dirname(__FILE__) + "/../lib/renshi")


def read_file(file_name)
  file = File.read(File.expand_path(File.dirname(__FILE__) + "/#{file_name}"))
end

def interpret(file, context)
  compiled = Renshi::Parser.parse(read_file(file))
  eval(compiled, context)
end