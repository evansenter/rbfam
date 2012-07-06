Gem::Specification.new do |spec|
  spec.name        = "rbfam"
  spec.version     = "0.0.1"
  spec.date        = "2012-07-06"
  spec.summary     = "Bindings to Rfam."
  spec.description = "Light wrapper for RFam data in Ruby."
  spec.authors     = ["Evan Senter"]
  spec.email       = "evansenter@gmail.com"
  spec.files       = Dir[File.join(File.dirname(__FILE__), "lib", "**", "*")]
  spec.homepage    = "http://rubygems.org/gems/rbfam"
  
  spec.add_dependency("bio", [">= 1.4.2"])
end