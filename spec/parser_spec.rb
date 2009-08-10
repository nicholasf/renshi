require File.dirname(__FILE__) + '/spec_helper'
require 'nokogiri'

def N(str)
  Nokogiri::XML(str)
end

describe Renshi::Parser do  
    it "should parse a $foo var in elements" do
      title = "hello world"
      out = interpret("data/hello_world1.ren", binding)
    
      doc = Nokogiri::XML(out)
      (doc/"title").text.should eql "hello world"
    end
    
    it "should interpret vars surrounded by whitespace" do 
      foo = "in space no one can hear you scream"
      out = interpret("data/white_space.ren", binding)
      doc = N(out)
      (doc/"div[@id='content']").text.strip.should eql "in space no one can hear you scream"
    end  
    
    it "should ignore $(..)" do      
      doc = Nokogiri::HTML.fragment("$(foo)")
      node = doc.children.first
      eval(deliver_compiled(node), binding).should eql "$(foo)"
    end
    
    it "should parse attribute values - e.g. <div id='content$i'>" do
      i = 1
      html = interpret("data/attribute_values_parsed.ren", binding)
      html = N(html)
      (html/"div[@id='content1']").text.strip.should =~ /hello/      
    end
    
    def foo(one, two, three = {})
      "#{one}, #{two}"
    end
    
    it "should understand double quotations marks within ruby code!" do
      #${link_to "alter this template", edit_cms_page_template_path(PageTemplate.find_by_file_name("default.html.erb"))}       
      raw = compile_file("data/quots.ren")
      html = eval(raw, binding)
      html = N(html)
      (html/"div[@id='content']").text.strip.should =~ /1, 2/      
    end
    

    it "should understand double quotations marks within ruby code! 2" do
      doc = Nokogiri::HTML(%Q!<p>${foo "1", foo("3", "4")}</p>!)
      
      puts doc.root
    
      body = doc.root.children.first
      node = body.children.first
      eval(deliver_compiled(node), binding).should eql "1, 3, 4"
    end
end