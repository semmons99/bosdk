require 'rubygems'
require 'rake'
require 'rake/clean'

CLOBBER.include 'pkg'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "bosdk"
    gem.summary = "JRuby Business Object Java SDK wrapper"
    gem.description = "A JRuby wrapper for the Business Objects Java SDK"
    gem.email = "semmons99@gmail.com"
    gem.homepage = "http://semmons99.github.com/bosdk"
    gem.authors = ["Shane Emmons"]
    gem.platform = Gem::Platform::CURRENT
    gem.requirements = "An environment variable 'BOE_JAVA_LIB' pointing to the Business Objects Java SDK directory"
    gem.add_development_dependency "rspec", ">= 1.3.0"
    gem.add_development_dependency "hanna", ">= 0.1.12"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
  spec.spec_opts << '--format specdoc'
end

task :spec => :check_dependencies

task :default => :spec

require 'hanna/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "bosdk #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
