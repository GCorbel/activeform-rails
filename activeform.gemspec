$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "activeform/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "activeform-rails"
  s.version     = Activeform::VERSION
  s.authors     = ["Guirec Corbel"]
  s.email       = ["guirec.corbel@gmail.com"]
  s.homepage    = "https://github.com/GCorbel/ActiveForm"
  s.summary     = "Form Objects for ActiveModel"
  s.description = "Enable to use the concept of form objects with ActiveModel"
  s.license    = "MIT"

  s.files = Dir["lib/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "activemodel", "~> 3"

  s.add_development_dependency "sqlite3", "~> 1"
  s.add_development_dependency "rspec", "~> 2"
end
