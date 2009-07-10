require File.dirname(__FILE__) + '/spec_helper'
require 'nokogiri'

describe Renshi::Parser do      
  it "should evaluate r:while" do
    foo = 0
    compiled = compile_file("data/while.ren")    
    out = eval compiled    
    doc = N(out)
    (doc/"div[@id='content0']").text.strip.should =~ /hello0/
    (doc/"div[@id='content1']").text.strip.should =~ /hello1/
    
    puts doc
  end   
end