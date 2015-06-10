# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

require 'middleman-wordpress/version'

Gem::Specification.new do |s|
  s.name        = "middleman-wordpress"
  s.version     = MiddlemanWordPress::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Nickolas Kenyeres"]
  s.email       = ["nkenyeres@gmail.com"]
  s.homepage    = "https://github.com/knicklabs/middleman-wordpress"
  s.summary     = %q{An extension for Middleman that pulls content from WordPress via WP REST API}
  s.description = %q{An extension for Middleman that enables the building of static websites using WordPress-managed content. This extension pulls content from WordPress via the WP REST API plugin for WordPress.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # The version of middleman-core your extension depends on
  s.add_runtime_dependency("middleman-core", [">= 3.3.12"])
  s.add_runtime_dependency("wp-api", [">= 0.1.3"])

  # Additional dependencies
  # s.add_runtime_dependency("gem-name", "gem-version")
end
