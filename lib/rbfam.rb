require "json"
require "bio"
require "vienna_rna"
require "entrez"
require "httparty"
require "active_support/inflector"

%W|helpers modules|.each do |folder|
  Dir[File.join(File.dirname(__FILE__), "rbfam", folder, "*.rb")].each { |name| require "rbfam/#{folder}/#{File.basename(name, '.rb')}" }
end

module Rbfam
  def self.script(name)
    require "rbfam/scripts/#{File.basename(name, '.rb')}"
  end
end

Rbfam::Family.const_set(:READABLE, JSON.parse(File.read(File.join(File.dirname(__FILE__), "rbfam", "helpers", "simple_names.json"))))