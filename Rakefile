require 'rubygems'
require 'rake/gempackagetask'


require File.dirname(__FILE__) + '/lib/renshi'

require 'spec'
require 'spec/rake/spectask'

gem_spec = Gem::Specification.new do |s| 
  s.name = "renshi"
  s.version = "0.2.4"
  s.author = "Nicholas Faiz"
  s.email = "nicholas.faiz@gmail.com"
  s.homepage = "http://github.com/biv/renshi/tree/master"
  s.platform = Gem::Platform::RUBY
  s.summary = "Renshi is a templating language for Ruby which is versatile and cooperative with HTML."
  s.files = FileList["{bin,lib}/**/*"].to_a
  s.require_path = "lib"
  s.autorequire = "renshi"
  s.test_files = FileList["{spec}/**/*"].to_a
  s.has_rdoc = true
  s.extra_rdoc_files = ["README"]
  s.add_dependency("nokogiri", ">= 1.2.3")
end
 
Rake::GemPackageTask.new(gem_spec) do |pkg| 
  pkg.need_tar = true 
end 


desc "Run the specs under spec/"
Spec::Rake::SpecTask.new do |t|
  t.spec_opts = ['--options', "spec/spec.opts"]
  t.spec_files = FileList['spec/*_spec.rb']
end
