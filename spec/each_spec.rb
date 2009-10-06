require File.dirname(__FILE__) + '/spec_helper'
require 'nokogiri'

describe Renshi::Parser do      
  it "should evaluate r:each" do
    foos = [0,1,2]
    doc = Nokogiri::HTML("<span id='red$foo' r:each='foos, |foo|'>hello$foo</span>")
    compiled = Renshi::Parser.parse(doc.root.to_s)
    doc = eval(compiled, binding)
    doc = N(doc)
    (doc/"span[@id='red0']").text.strip.should eql "hello0"
    (doc/"span[@id='red1']").text.strip.should eql "hello1"
    (doc/"span[@id='red2']").text.strip.should eql "hello2"
  end   


  class Foo
    attr_accessor :results
    def initialize
      @results = {"earth" => {"hello" => "world"}}
    end
  end
  # <li r:each="@sphinx_results.results[:words], |k,v|">
  #  $k - Hits $v[:hits] in $v[:docs] documents
  #  </li>  
  it "should evaluate complex r:each" do
    str = %Q!<div id="test"><li r:each="@foo.results['earth'], |k,v|">$k $v</li></div>!
    @foo = Foo.new
    compiled = Renshi::Parser.parse(str)
    doc = eval(compiled, binding)
    doc = N(doc)
    (doc/"div[@id='test']").text.strip.should =~ /hello world/
  end
end