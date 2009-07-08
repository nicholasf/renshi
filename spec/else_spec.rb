require File.dirname(__FILE__) + '/spec_helper'
require 'nokogiri'

describe Renshi::Parser do      
  it "should evaluate r:else" do
    foo = true
    out = interpret("data/ifelse.ren", binding)
    doc = N(out)
    (doc/"div[@id='content']").text.strip.should =~ /hello/      
    (doc/"div[@id='inner_content']").text.strip.should eql "world"
  
    foo = false
  
    out = interpret("data/ifelse.ren", binding)
    doc = N(out)
    (doc/"div[@id='content']").text.strip.should =~ /goodbye/      
  end   
end