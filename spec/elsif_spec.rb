require File.dirname(__FILE__) + '/spec_helper'
require 'nokogiri'

describe Renshi::Parser do
  it "should evaluate r:elsif" do
    foo = true
    bar = false
    out = interpret("data/ifelsifelse.ren", binding)
    doc = N(out)
    (doc/"div[@id='content']").text.strip.should =~ /hello/      
    (doc/"div[@id='inner_content']").text.strip.should eql "world"
  
    foo = false
    bar = true
    out = interpret("data/ifelsifelse.ren", binding)
    doc = N(out)
    (doc/"div[@id='content']").text.strip.should =~ /neither/      
  end
  
  it "should evaluate many of them" do
    foo = 1
    out = interpret("data/elsif2.ren", binding)
    doc = N(out)
    (doc/"div[@id='content']").text.strip.should =~ /1/
    foo = 3
    out = interpret("data/elsif2.ren", binding)
    doc = N(out)
    (doc/"div[@id='content']").text.strip.should =~ /3/
  end
end