require File.dirname(__FILE__) + '/spec_helper'
require 'nokogiri'

def N(str)
  Nokogiri::XML(str)
end

describe Renshi do
  
  it "should parse a $foo var in elements" do
    title = "hello world"
    out = Renshi.parse(read_file("data/hello_world1.ren"), binding)
    doc = Nokogiri::XML(out)
    (doc/"title").text.should eql "hello world"
  end
  
  it "should interpret vars surrounded by whitespace" do 
    foo = "in space no one can hear you scream"
    out = Renshi.parse(read_file("data/white_space.ren"), binding)
    doc = N(out)
    (doc/"div[@id='content']").text.strip.should eql "in space no one can hear you scream"
  end  

  it "should evaluate r:ifs" do
    foo = true
    out = Renshi.parse(read_file("data/if_1.ren"), binding)
    doc = N(out)
    (doc/"div[@id='content']").text.strip.should eql "hello"
    
    foo = false
    out = Renshi.parse(read_file("data/if_1.ren"), binding)
    doc = N(out)
    body = doc.root.children.first
    body.children.size.should eql 1
  end

  it "another r:if test" do
    foo = true
    out = Renshi.parse(read_file("data/if_2.ren"), binding)
    doc = N(out)
    (doc/"div[@id='content']").text.strip.should eql "hello"
  end
end