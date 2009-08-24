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
    
    def foo(one, two = "", three = {})
      "#{one}, #{two}"
    end
    
    it "should understand double quotations marks within ruby code!" do
      #${link_to "alter this template", edit_cms_page_template_path(PageTemplate.find_by_file_name("default.html.erb"))}       
      raw = compile_file("data/quots.ren")
      html = eval(raw, binding)
      html = N(html)
      (html/"div[@id='content']").text.strip.should =~ /1, 2/      
    end
    
    it "should understand double quotations marks within ruby code!" do
      #${link_to "alter this template", edit_cms_page_template_path(PageTemplate.find_by_file_name("default.html.erb"))}       
      raw = compile_file("data/quots2.ren")
      html = eval(raw, binding)
      html = N(html)
      (html/"div[@id='content']").text.strip.should =~ /1, 2/      
      (html/"div[@id='content2']").text.strip.should =~ /a, 2/      
    end
    
    it "should understand double quotations marks within ruby code! 2" do
      doc = Nokogiri::HTML(%Q!<p>${foo "1", foo("3", "4")}</p>!)
      
      puts doc.root
    
      body = doc.root.children.first
      node = body.children.first
      eval(deliver_compiled(node), binding).should eql "1, 3, 4"
    end
    
    it "should understand multiple statements on the same line" do    
      raw = compile_file("data/multiple_statements.ren")
      html = eval(raw, binding)
      html = N(html)
      (html/"div[@id='content']").text.strip.should =~ /1, 2, 3, 4/      
      (html/"div[@id='content2']").text.strip.should =~ /1, 2/      
    end
    
    
     # STRING_END = "^R_END" #maybe replace this with a funky unicode char
     # STRING_START = "^R_START" #maybe replace this with a funky unicode char
     # BUFFER_CONCAT_OPEN = "@output_buffer.concat(\""
     # BUFFER_CONCAT_CLOSE = "\");"
     # NEW_LINE = "@output_buffer.concat('\n');"
     # INSTRUCTION_START = "^R_INSTR_IDX_START^"
     # INSTRUCTION_END = "^R_INSTR_IDX_END^"
    
    
    it "should interpret all Renshi instructions and remove them from the document" do
      raw = compile_file("data/example1.ren")
      html = eval(raw, binding)

      html.should_not =~/R_INSTR_IDX_START/
      html.should_not =~/R_INSTR_IDX_END/
      html.should_not =~/@output_buffer.concat/
      html.should_not =~/R_START/
      html.should_not =~/R_END/
    end
    
    it "should not remove the header of the document" do
      raw = compile_file("data/example1.ren")
      html = eval(raw, binding)
      
      html.should =~/head/
    end
    
    it "should interpret single $foos using \W, i.e. $foo$bar should render" do
      raw = Renshi::Parser.parse("$foo$bar")
      foo = "hello"
      bar = " world"
      
      html = eval(raw, binding)
      
      html.should eql "hello world"
    end

class Test
  def bar
    return "hello world"
  end
end
    
    it "should interpret single $foo.bar " do
      raw = Renshi::Parser.parse("$foo.bar")
      foo = Test.new
      html = eval(raw, binding)
      
      html.should eql "hello world"
    end
    
    it "should interpret single $1+1 and $2*2 and $3/3 and $4-4 " do
      raw = Renshi::Parser.parse("$1+1")
      foo = Test.new
      html = eval(raw, binding)  
      html.should eql "2"
      
      raw = Renshi::Parser.parse("$2*2")
      foo = Test.new
      html = eval(raw, binding)  
      html.should eql "4"

      raw = Renshi::Parser.parse("$3/3")
      foo = Test.new
      html = eval(raw, binding)  
      html.should eql "1"

      raw = Renshi::Parser.parse("$4-4")
      foo = Test.new
      html = eval(raw, binding)  
      html.should eql "0"
    end
    
    
    it "should interpret $foo[0] " do
      raw = Renshi::Parser.parse("$foo[0]")
      foo = ["hello world"]
      html = eval(raw, binding)
      
      html.should eql "hello world"
    end
end