require File.dirname(__FILE__) + '/spec_helper'
require 'nokogiri'

describe Renshi::Parser do      
  it "should evaluate r:unless(false)" do
    doc = Nokogiri::HTML("<span r:unless='false'/>hello</span>")
    compiled = deliver_compiled(doc.root)
    puts compiled
    eval(compiled, binding).should eql "hello"
  end   
end