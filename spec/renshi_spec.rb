require File.dirname(__FILE__) + '/spec_helper'
require 'nokogiri'

describe Renshi do
  
  it "should parse $foo vars in elements" do
    context = {:title => "hello world"}
    out = Renshi.parse(read_file("data/hello_world1.ren"), context)
    doc = Nokogiri::XML(out)
    (doc/"title").text.should eql "hello world"
  end
  
end