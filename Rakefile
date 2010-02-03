require 'rake/clean'

CLEAN.include %w( doc )
CLOBBER.include %w( *.gem )

desc 'generate documentation'
task :rdoc do
  sh 'hanna README.rdoc MIT-LICENSE lib -U'
end

desc 'build gem'
task :gem => :clobber do
  sh 'gem build bosdk.gemspec'
end

desc 'upload gem'
task :upload => :gem do
  Dir.glob('bosdk*.gem') do |gem|
    sh "gem push #{gem}"
  end
end

desc 'run unit tests'
task :test do
  ruby '-S spec -f s -c spec/*_spec.rb'
end
