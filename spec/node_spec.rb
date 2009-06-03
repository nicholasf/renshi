require File.dirname(__FILE__) + '/spec_helper'
require 'nokogiri'

describe Renshi::Node do
  
  def deliver_compiled(node)
    raw = node.interpret
    raw = Renshi::Parser.compile_to_buffer(raw)    
  end
  
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
     eval(deliver_compiled(node), binding).should eql foo
   end
     
   it "should interpret $foo $bar" do
     foo = "hello"
     bar = "world"
     doc = Nokogiri::HTML("$foo $bar")
     
     body = doc.root.children.first
     node = body.children.first
     eval(deliver_compiled(node), binding).should eql "#{foo} #{bar}"
   end
   
   it "should interpret ${1 + 1}" do
     doc = Nokogiri::HTML("${eval 1 + 1}")
     body = doc.root.children.first
     node = body.children.first
     # node.interpret(binding).should eql "2"
     puts deliver_compiled(node)
     eval(deliver_compiled(node), binding).should eql "2"     
   end  
   
   # it "should interpret ${1 + 1} $foo" do
   #   foo = "is a number"
   #   doc = Nokogiri::HTML("${1 + 1} $foo")
   #   body = doc.root.children.first
   #   node = body.children.first
   #   # node.interpret(binding).should eql "2 is a number"
   #   eval(deliver_compiled(node), binding).should eql "2 is a number"
   # end
   #  
   # it "should interpret ${[0,1,2,3,4].each {|i| print i}}" do
   #   foo = "is a number"
   #   doc = Nokogiri::HTML("${[0,1,2,3,4].each {|i| print i}}")
   #   body = doc.root.children.first
   #   node = body.children.first
   #   # node.interpret(binding).should eql "01234"
   #   eval(deliver_compiled(node), binding).should eql "01234"
   # end
   # 
   # it "should update the binding after each execution" do
   #   doc = Nokogiri::HTML("${foo = 'hello'}$foo")
   #   body = doc.root.children.first
   #   node = body.children.first
   #   # node.interpret(binding).should eql "hello"    
   #   eval(deliver_compiled(node), binding).should eql "hello"
   # end
end