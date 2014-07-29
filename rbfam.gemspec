Gem::Specification.new do |spec|
  spec.name        = "rbfam"
  spec.version     = "0.1.3"
  spec.summary     = "Bindings to Rfam."
  spec.description = "Light wrapper for RFam data in Ruby."
  spec.authors     = ["Evan Senter"]
  spec.email       = "evansenter@gmail.com"
  spec.files       = Dir["{lib,db,bin}/**/*", "LICENSE", "*.md"]
  spec.homepage    = "http://rubygems.org/gems/rbfam"
  
  spec.add_runtime_dependency("bio",                   "~> 1.4", ">= 1.4.2")
  spec.add_runtime_dependency("entrez",                "~> 0.5", ">= 0.5.8.1")
  spec.add_runtime_dependency("httparty",              "~> 0.8", ">= 0.8.3")
  spec.add_runtime_dependency("wrnap",                 ">= 0.1.3")
  spec.add_runtime_dependency("nokogiri",              "~> 1.6", ">= 1.6.1")
  spec.add_runtime_dependency("mysql2",                "~> 0.3", ">= 0.3.14")
  spec.add_runtime_dependency("bio-stockholm",         "~> 0.0", ">= 0.0.1")
  spec.add_runtime_dependency("activerecord")
  spec.add_runtime_dependency("activesupport")
end
