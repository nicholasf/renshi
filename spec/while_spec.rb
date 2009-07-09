require File.dirname(__FILE__) + '/spec_helper'
require 'nokogiri'

describe Renshi::Parser do      
  it "should evaluate r:while" do
    foo = 0
    out = interpret("data/while.ren", binding)
    doc = N(out)
    puts doc.to_s
    (doc/"div[@id='content']").text.strip.should =~ /hello0/
    (doc/"div[@id='content']").text.strip.should =~ /hello1/
  end   
end