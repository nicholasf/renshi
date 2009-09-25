require File.dirname(__FILE__) + '/spec_helper'
require 'nokogiri'

describe Renshi::Parser do      
  it "should evaluate r:unless(false)" do
    doc = Nokogiri::HTML("<span id='red' r:unless='foo'>hello</span>")
    compiled = Renshi::Parser.parse(doc.root.to_s)
    foo = false
    out = eval(compiled, binding)
    out = N(out)
    (out/"span[@id='red']").text.strip.should eql "hello"

    foo = true
    out = eval(compiled, binding)
    out = N(out)
    (out/"span[@id='red']").text.strip.should eql ""
  end   
  
  it "should ... " do
    foo = true
    compiled = compile_file("data/unless.ren")
    puts compiled
    out = eval compiled, binding
  
    out.should_not =~ /hello/
  end
end