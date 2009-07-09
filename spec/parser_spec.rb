require File.dirname(__FILE__) + '/spec_helper'
require 'nokogiri'

def N(str)
  Nokogiri::XML(str)
end

describe Renshi::Parser do  
    it "should parse a $foo var in elements" do
      title = "hello world"
      out = interpret("data/hello_world1.ren", binding)
    
      doc = Nokogiri::XML(out)
      (doc/"title").text.should eql "hello world"
    end
    
    it "should interpret vars surrounded by whitespace" do 
      foo = "in space no one can hear you scream"
      out = interpret("data/white_space.ren", binding)
      doc = N(out)
      (doc/"div[@id='content']").text.strip.should eql "in space no one can hear you scream"
    end  
    
    it "should ignore $(..)" do      
      doc = Nokogiri::HTML.fragment("$(foo)")
      node = doc.children.first
      eval(deliver_compiled(node), binding).should eql "$(foo)"
    end
    
    it "should parse attribute values - e.g. <div id='content$i'>" do
      i = 1
      html = interpret("data/attribute_values_parsed.ren", binding)
      html = N(html)
      (html/"div[@id='content1']").text.strip.should =~ /hello/      
    end
end