require 'rubygems'
require 'rake/clean'

CLOBBER.include('doc', '.yardoc')

def gemspec
  @gemspec ||= begin
    file = File.expand_path("../bosdk.gemspec", __FILE__)
    eval(File.read(file), binding, file)
  end
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new
task :default => :spec
task :test => :spec

require 'yard'
YARD::Rake::YardocTask.new

require 'rake/gempackagetask'
Rake::GemPackageTask.new(gemspec) do |pkg|
  pkg.gem_spec = gemspec
end
task :gem => :gemspec

desc "Validate the gemspec"
task :gemspec do
  gemspec.validate
end
