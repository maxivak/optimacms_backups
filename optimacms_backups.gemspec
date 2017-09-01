$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "optimacms_backups/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "optimacms_backups"
  s.version     = OptimacmsBackups::VERSION
  s.authors     = ["Max Ivak"]
  s.email       = ["max.ivak@gmail.com"]
  s.homepage    = "https://github.com/maxivak/optimacms_backups"
  s.summary     = "Backups for OptimaCMS."
  s.description = "Backups manager module for Optima CMS."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", ">= 4.2"

  s.add_dependency "optimacms"
  s.add_dependency "backup"
  s.add_dependency "backup-remote"

  #s.add_development_dependency "sqlite3"
end
