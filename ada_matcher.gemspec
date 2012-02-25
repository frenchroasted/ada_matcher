# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ada_matcher/version"

Gem::Specification.new do |s|
  s.name        = "ada_matcher"
  s.version     = AdaMatcher::VERSION
  s.authors     = ["Aaron Brown"]
  s.email       = ["aaron@thebrownproject.com"]
  s.homepage    = ""
  s.summary     = %q{Adds custom rspec matchers that test watir Page objects for ADA compliance}
  s.description = %q{Adds custom rspec matchers that test watir Page objects for ADA compliance}
  s.license     = 'MIT'

  s.rubyforge_project = "ada_matcher"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  s.add_development_dependency "watir-webdriver", ">0"
  s.add_development_dependency "headless"
  s.add_runtime_dependency "rspec"
end
