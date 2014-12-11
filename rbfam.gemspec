# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rbfam/version'

Gem::Specification.new do |spec|
  spec.name          = "rbfam"
  spec.version       = Rbfam::VERSION
  spec.authors       = ["Evan Senter"]
  spec.email         = ["evansenter@gmail.com"]
  spec.summary       = %q{Bindings to Rfam.}
  spec.description   = %q{Light wrapper for RFam data in Ruby.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  
  spec.required_ruby_version = ">= 2.0"

  spec.add_development_dependency "standalone_migrations", "~> 2.1", ">= 2.1.5"
  
  spec.add_runtime_dependency "activerecord"
  spec.add_runtime_dependency "activesupport"
  spec.add_runtime_dependency "bio",                   "~> 1.4", ">= 1.4.2"
  spec.add_runtime_dependency "bio-stockholm",         "~> 0.0", ">= 0.0.1"
  spec.add_runtime_dependency "entrez",                "~> 0.5", ">= 0.5.8.1"
  spec.add_runtime_dependency "httparty",              "~> 0.8", ">= 0.8.3"
  spec.add_runtime_dependency "mysql2",                "~> 0.3", ">= 0.3.14"
  spec.add_runtime_dependency "nokogiri",              "~> 1.6", ">= 1.6.1"
  spec.add_runtime_dependency "parallel",              "~> 1.3", ">= 1.3.2"
end
