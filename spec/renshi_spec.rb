require File.dirname(__FILE__) + '/spec_helper'
require 'nokogiri'

describe Renshi do
  
  it "should parse a $foo var in elements" do
    context = {:title => "hello world"}
    out = Renshi.parse(read_file("data/hello_world1.ren"), context)
    doc = Nokogiri::XML(out)
    (doc/"title").text.should eql "hello world"
  end
  
  it "should interpret vars surrounded by whitespace" do 
    context = {:foo => "in space no one can hear you scream"}
    out = Renshi.parse(read_file("data/white_space.ren"), context)
    doc = N(out)
    (doc/"div[@id='content']").text.strip.should eql "in space no one can hear you scream"
  end  

  
  def N(str)
    Nokogiri::XML(str)
  end
end