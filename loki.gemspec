# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "loki/version"

Gem::Specification.new do |s|
  s.name        = "loki"
  s.version     = Loki::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Patrick Hogan"]
  s.email       = ["pbhogan@gmail.com"]
  s.homepage    = "https://github.com/pbhogan/loki"
  s.summary     = "A highly experimental and simplistic Rake-like DSL."
  s.description = s.summary

  # s.rubyforge_project = "loki"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
