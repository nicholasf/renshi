require File.dirname(__FILE__) + '/spec_helper'
require 'nokogiri'

describe Renshi::Parser do      
  it "should evaluate r:unless(false)" do
    doc = Nokogiri::HTML("<span id='red' r:unless='false'>hello</span>")
    compiled = Renshi::Parser.parse(doc.root.to_s)
    puts compiled
    out = eval(compiled, binding)
    out = N(out)
    (out/"span[@id='red']").text.strip.should eql "hello"
  end   
end