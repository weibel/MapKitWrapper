# -*- encoding: utf-8 -*-
require File.expand_path('../lib/map_kit_wrapper/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Kasper Weibel Nielsen-Refs"]
  gem.email         = ["weibel@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "map_kit_wrapper"
  gem.require_paths = ["lib"]
  gem.version       = MapKit::VERSION

  gem.add_dependency 'bubble-wrap'
  gem.add_development_dependency 'rake'
end
