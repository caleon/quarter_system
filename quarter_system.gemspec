$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "quarter_system/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "quarter_system"
  s.version     = QuarterSystem::VERSION
  s.authors     = ["caleon"]
  s.email       = ["caleon@gmail.com"]
  s.homepage    = "http://github.com/caleon/quarter_system"
  s.summary     = %q{Class Quarter for handling with the division of a calendar year into an arbitrary grouping of quarters, by default, the US fiscal calendar.}
  s.description = %q{Class Quarter for handling with the division of a calendar year into an arbitrary grouping of quarters, by default, the US fiscal calendar.}

  s.rubyforge_project = "quarter_system"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_development_dependency 'rails', '>= 3.1.1'
  s.add_dependency 'schrodinger', '>= 0.1.2'  
  s.add_development_dependency 'sqlite3'
end
