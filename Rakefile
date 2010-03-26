require 'rubygems'
require 'rake'
require 'rake/clean'

CLOBBER.include 'pkg'
CLOBBER.include 'doc'
CLOBBER.include '.yardoc'

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
    gem.rubyforge_project = "bosdk"
    gem.requirements = "An environment variable 'BOE_JAVA_LIB' pointing to the Business Objects Java SDK directory"
    gem.add_development_dependency "rspec", ">= 1.3.0"
    gem.add_development_dependency "yard", ">= 0.5.4"
  end
  Jeweler::GemcutterTasks.new
  Jeweler::RubyforgeTasks.new do |gem|
    gem.remote_doc_path = ""
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

desc "Run specs with '--format specdoc'"
Spec::Rake::SpecTask.new(:specdoc) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
  spec.spec_opts << '--format specdoc'
end

task :spec => :check_dependencies

task :default => :spec

task :test => :spec

require 'yard'
YARD::Rake::YardocTask.new
