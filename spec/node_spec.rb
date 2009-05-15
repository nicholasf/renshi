require File.dirname(__FILE__) + '/spec_helper'
require 'nokogiri'

describe Renshi::Node do

  it "should return the commands in an XML element's attributes" do
    doc = Nokogiri::HTML("<span r:if='true' r:while='true'/>")
    
    body = doc.root.children.first
    node = body.children.first
    node.attributes.size.should eql 2
    node.commands.size.should eql 2
  end
end