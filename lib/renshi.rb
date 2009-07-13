$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

# Renshi's aim is to be a lightweight library with dependencies solely on nokogiri.  
require 'nokogiri'
require 'renshi/parser'
require 'renshi/node'
require 'renshi/attribute_expressions'
require 'renshi/frameworks'

module Renshi
  VERSION="0.0.8"
  
  class SyntaxError < StandardError; end
end

Nokogiri::XML::Node.send(:include, Renshi::Node)
Renshi::Frameworks.notice