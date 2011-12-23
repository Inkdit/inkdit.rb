# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "inkdit/version"

Gem::Specification.new do |s|
  s.name        = "inkdit"
  s.version     = Inkdit::VERSION
  s.authors     = ["Brendan Taylor"]
  s.email       = ["brendan@inkdit.com"]
  s.homepage    = "https://developer.inkdit.com/"
  s.summary     = %q{A library for using the Inkdit API to sign, share and store contracts}
  s.description = %q{This is both a working Ruby gem and a code sample that other client implementations can work from.}

  s.rubyforge_project = "inkdit"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "oauth2"

  # documentation
  s.add_development_dependency "yard"

  # test dependencies
  s.add_development_dependency "rspec"
  s.add_development_dependency "vcr"

  # dependencies for our access token getter
  s.add_development_dependency "sinatra"
  s.add_development_dependency "haml"
end
