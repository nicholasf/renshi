require 'rubygems'
require 'spec'
require 'ruby-debug'
require File.expand_path(File.dirname(__FILE__) + "/../lib/renshi")


def read_file(file_name)
  file = File.read(File.expand_path(File.dirname(__FILE__) + "/#{file_name}"))
end