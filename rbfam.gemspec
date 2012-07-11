Gem::Specification.new do |spec|
  spec.name        = "rbfam"
  spec.version     = "0.0.2"
  spec.date        = "2012-07-06"
  spec.summary     = "Bindings to Rfam."
  spec.description = "Light wrapper for RFam data in Ruby."
  spec.authors     = ["Evan Senter"]
  spec.email       = "evansenter@gmail.com"
  spec.files       = Dir[File.join(File.dirname(__FILE__), "lib", "**", "*")]
  spec.homepage    = "http://rubygems.org/gems/rbfam"
  
  spec.add_dependency("bio", [">= 1.4.2"])
  spec.add_dependency("entrez", [">= 0.5.8.1"])
  spec.add_dependency("httparty", [">= 0.8.3"])
  spec.add_dependency("vienna_rna", [">= 0.1.3"])
end