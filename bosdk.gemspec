Gem::Specification.new do |s|
  s.name        = "bosdk"
  s.version     = "1.1.1"
  s.platform    = "java"
  s.authors     = ["Shane Emmons"]
  s.email       = "semmons99@gmail.com"
  s.homepage    = "http://semmons99.github.com/bosdk"
  s.summary     = "JRuby Business Object Java SDK wrapper"
  s.description = "A JRuby wrapper for the Business Objects Java SDK"

  s.required_rubygems_version = ">= 1.3.6"

  s.requirements = ["An environment variable 'BOE_JAVA_LIB' pointing to the Business Objects Java SDK directory"]

  s.add_development_dependency "rspec", ">= 2.0.0"
  s.add_development_dependency "yard"

  s.files         = Dir.glob("{bin,lib}/**/*") + %w(README.md)
  s.executables   = ["boirb"]
  s.require_path  = "lib"
end

