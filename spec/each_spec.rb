require File.dirname(__FILE__) + '/spec_helper'
require 'nokogiri'

describe Renshi::Parser do      
  it "should evaluate r:unless(false)" do
    foos = [0,1,2]
     doc = Nokogiri::HTML("<span id='red$foo' r:each='foos, |foo|'/>hello$foo</span>")
     compiled = Renshi::Parser.parse(doc.root.to_s)
     out = eval(compiled, binding)
    (doc/"span[@id='red0']").text.strip.should eql "hello0"
    (doc/"span[@id='red1']").text.strip.should eql "hello1"
    (doc/"span[@id='red2']").text.strip.should eql "hello2"
  end   
end