require File.dirname(__FILE__) + '/spec_helper'
require 'nokogiri'

describe Renshi::Parser do      
    it "should evaluate r:ifs" do
      foo = true
      out = interpret("data/if_1.ren", binding)
      doc = N(out)
      (doc/"div[@id='content']").text.strip.should eql "hello"
      
      foo = false
      out = interpret("data/if_1.ren", binding)
      doc = N(out)
      (doc/"div[@id='content']").text.strip.should eql ""
    end
    
    it "another r:if test" do
      foo = true
      out = interpret("data/if_2.ren", binding)
      doc = N(out)
      (doc/"div[@id='content']").text.strip.should eql "hello"
    end
    
    it "should evaluate nested r:ifs" do
      foo = true
      out = interpret("data/if_3.ren", binding)
      doc = N(out)
      (doc/"div[@id='content']").text.strip.should =~ /hello/      
      (doc/"div[@id='inner_content']").text.strip.should eql "world"
    end   
    
    # it "trying to replicate a problem ..." do
    #   @foos = [1, 2]
    #   raw = Renshi::Parser.parse("<p r:if='@foos.empty?'>hello</p>")
    #   html = eval(raw, binding)
    #   
    #   html.should eql ""
    # end
end