Gem::Specification.new do |s|
  s.name = "bosdk"
  s.version = "1.0.1"
  
  s.author = "Shane Emmons"
  s.description = "A JRuby wrapper for the Business Objects Java SDK"
  s.email = "semmons99@gmail.com"
  s.files = [
    "README.rdoc", "MIT-LICENSE", "bosdk.gemspec", "Rakefile",
    "lib/bosdk.rb",
    "lib/bosdk/enterprise_session.rb",
    "lib/bosdk/info_object.rb",
    "lib/bosdk/webi_report_engine.rb",
    "spec/enterprise_session_spec.rb",
    "spec/info_object_spec.rb",
    "spec/webi_report_engine_spec.rb",
  ]

  s.homepage = "http://semmons99.github.com/bosdk"
  s.summary = "JRuby Business Object Java SDK wrapper"
  s.platform = Gem::Platform::CURRENT
  s.requirements = "An environment variable 'BOE_JAVA_LIB' pointing to the Business Objects Java SDK directory"
end
