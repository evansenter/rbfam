require "bio"
require "vienna_rna"
require "entrez"
require "httparty"
require "active_support/inflector"

Dir[File.join(File.dirname(__FILE__), "rbfam", "modules", "*.rb")].each { |name| require "rbfam/modules/#{File.basename(name, '.rb')}" }

module Rbfam
  def self.script(name)
    require "rbfam/scripts/#{File.basename(name, '.rb')}"
  end
end