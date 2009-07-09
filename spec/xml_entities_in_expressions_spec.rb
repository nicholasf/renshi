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
end