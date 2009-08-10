require 'rubygems'
require 'spec'
require 'ruby-debug'
require File.expand_path(File.dirname(__FILE__) + "/../lib/renshi")


def read_file(file_name)
  file = File.read(File.expand_path(File.dirname(__FILE__) + "/#{file_name}"))
end

def compile_file(file)
  compiled = Renshi::Parser.parse(read_file(file))  
end

def interpret(file, context)
  eval(compile_file(file), context)
end

def deliver_compiled(node)
  raw = Renshi::Parser.parse(node.text)
end

def N(str)
  Nokogiri::XML(str)
end