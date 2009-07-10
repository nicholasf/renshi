require File.dirname(__FILE__) + '/spec_helper'
require 'nokogiri'

describe Renshi::Parser do      
  it "should evaluate r:while(foo < 2)" do
    foo = 0
    compiled = compile_file("data/while_lt.ren")
    out = eval compiled    
    doc = N(out)
    (doc/"div[@id='content0']").text.strip.should =~ /hello0/
    (doc/"div[@id='content1']").text.strip.should =~ /hello1/
  end   
  
  it "should evaluate r:if(foo < 2)" do
    doc = Nokogiri::HTML("<span r:if='1 < 2'>hello</div>")
    body = doc.root.children.first
    node = body.children.first
    eval(deliver_compiled(node), binding).should eql "hello"
  end   
  
  it "should evaluate r:elsif(foo < 2)" do
    doc = Nokogiri::HTML("<span r:if='false'/><span r:elsif='1 < 2'>hello</div>")
    compiled = deliver_compiled(doc.root)
    puts compiled
    eval(compiled, binding).should eql "hello"
  end   
end