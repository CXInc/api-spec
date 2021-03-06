# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'api_spec/version'

Gem::Specification.new do |spec|
  spec.name          = "api-spec"
  spec.version       = ApiSpec::VERSION
  spec.authors       = ["Bruz Marzolf"]
  spec.email         = ["bruz@bruzilla.com"]
  spec.summary       = %q{Helpers for writing cucumber API tests.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rest-client", "~> 1.7"
  spec.add_dependency "json_spec", "~> 1.1"
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
