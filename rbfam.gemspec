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

  spec.add_development_dependency "awesome_print", "~> 1.2.0"
  spec.add_development_dependency "bundler",       "~> 1.7"
  spec.add_development_dependency "gem-release",   "~> 0.7", ">= 0.7.3"
  spec.add_development_dependency "rake",          "~> 10.0"
  
  spec.add_runtime_dependency "activerecord",             "~> 4.2", ">= 4.2.0"
  spec.add_runtime_dependency "activerecord-import",      "~> 0.7", ">= 0.7.0"
  spec.add_runtime_dependency "active_record_migrations", "~> 4.2", ">= 4.2.0.1"
  spec.add_runtime_dependency "activesupport",            "~> 4.2", ">= 4.2.0"
  spec.add_runtime_dependency "bio",                      "~> 1.4", ">= 1.4.2"
  spec.add_runtime_dependency "bio-stockholm",            "~> 0.0", ">= 0.0.1"
  spec.add_runtime_dependency "mysql2",                   "~> 0.3", ">= 0.3.14"
  spec.add_runtime_dependency "parallel",                 "~> 1.3", ">= 1.3.2"
  spec.add_runtime_dependency "ruby-progressbar",         "~> 1.7", ">= 1.7.0"
  spec.add_runtime_dependency "virtus",                   "~> 1.0", ">= 1.0.3"
end
