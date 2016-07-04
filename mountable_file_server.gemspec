# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mountable_file_server/version'

Gem::Specification.new do |spec|
  spec.name          = "mountable_file_server"
  spec.version       = MountableFileServer::VERSION
  spec.authors       = ["David Strauß"]
  spec.email         = ["david@strauss.io"]
  spec.summary       = %q{Simple mountable server that handles file uploads}
  spec.description   = %q{}
  spec.homepage      = "https://github.com/stravid/mountable_file_server"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.8.0"
  spec.add_development_dependency "rails", "~> 4.2.3"
  spec.add_development_dependency "capybara", "~> 2.4.4"
  spec.add_development_dependency "sqlite3", "~> 1.3.10"
  spec.add_development_dependency "poltergeist", "~> 1.6.0"
  spec.add_development_dependency "rack-test", "~> 0.6.3"
  spec.add_development_dependency "bogus", "~> 0.1.6"

  spec.add_runtime_dependency "rack", "~> 1.6"
  spec.add_runtime_dependency "sinatra", "~> 1.4.5"
  spec.add_runtime_dependency "mini_magick"
  spec.add_runtime_dependency "url_safe_base64"

  spec.add_runtime_dependency "dry-configurable", "~> 0.1.6"
end
