require File.dirname(__FILE__) + '/spec_helper'
require 'nokogiri'

describe Renshi::Node do
  
  it "should return the commands in an XML element's attributes" do
    doc = Nokogiri::HTML("<span r:if='true' r:while='true'/>")
    
    body = doc.root.children.first
    node = body.children.first
    node.attributes.size.should eql 2
    node.commands.size.should eql 2
  end
  
  it "should interpret $foo" do
    foo = "hello world"
    doc = Nokogiri::HTML("$foo")
    
    body = doc.root.children.first
    node = body.children.first
    node.interpret(binding).should == foo
  end
    
  it "should interpret $foo $bar" do
    foo = "hello"
    bar = "world"
    doc = Nokogiri::HTML("$foo $bar")
    
    body = doc.root.children.first
    node = body.children.first
    node.interpret(binding).should == "#{foo} #{bar}"
  end
  
  it "should interpret ${1 + 1}" do
    doc = Nokogiri::HTML("${1 + 1}")
    body = doc.root.children.first
    node = body.children.first
    node.interpret(binding).should eql "2"
  end  
  
  it "should interpret ${1 + 1} $foo" do
    foo = "is a number"
    doc = Nokogiri::HTML("${1 + 1} $foo")
    body = doc.root.children.first
    node = body.children.first
    node.interpret(binding).should eql "2 is a number"
  end
   
  it "should interpret ${[0,1,2,3,4].each {|i| print i}}" do
    foo = "is a number"
    doc = Nokogiri::HTML("${[0,1,2,3,4].each {|i| print i}}")
    body = doc.root.children.first
    node = body.children.first
    node.interpret(binding).should eql "01234"
  end
end