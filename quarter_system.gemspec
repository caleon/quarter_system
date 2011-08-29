# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "quarter_system/version"

Gem::Specification.new do |s|
  s.name        = "quarter_system"
  s.version     = QuarterSystem::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Caleon Chun"]
  s.email       = ["colin@juscribe.com"]
  s.homepage    = ""
  s.summary     = %q{Class Quarter for handling with the division of a calendar year into an arbitrary grouping of quarters, by default, the US fiscal calendar.}
  s.description = %q{Class Quarter for handling with the division of a calendar year into an arbitrary grouping of quarters, by default, the US fiscal calendar.}

  s.rubyforge_project = "quarter_system"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency("argumentation", "~> 0.0.1")
end
