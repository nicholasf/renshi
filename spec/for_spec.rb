require File.dirname(__FILE__) + '/spec_helper'
require 'nokogiri'

describe Renshi::Parser do      
  it "should evaluate r:for" do
    foos = [0,1,2]
    compiled = compile_file("data/for.ren")    
    out = eval compiled    
    doc = N(out)
    puts out
    (doc/"div[@id='content0']").text.strip.should =~ /hello0/
    (doc/"div[@id='content1']").text.strip.should =~ /hello1/
    (doc/"div[@id='content2']").text.strip.should =~ /hello2/
  end   
end