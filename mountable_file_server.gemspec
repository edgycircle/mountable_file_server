# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mountable_file_server/version'

Gem::Specification.new do |spec|
  spec.name          = "mountable_file_server"
  spec.version       = MountableFileServer::VERSION
  spec.authors       = ["David Strauß"]
  spec.email         = ["david@strauss.io"]
  spec.summary       = %q{TODO: Write a short summary. Required.}
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = Dir["**/*"]
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "rails"
  spec.add_development_dependency "capybara"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "poltergeist"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "bogus"

  spec.add_runtime_dependency "gem_config"
  spec.add_runtime_dependency "sinatra"
end
