require "json"
require "bio"
require "wrnap"
require "entrez"
require "httparty"
require "bio-stockholm"
require "mysql2"
require "active_record"
require "active_support/inflector"

%W|helpers modules|.each do |folder|
  Dir[File.join(File.dirname(__FILE__), "rbfam", folder, "*.rb")].each { |name| require "rbfam/#{folder}/#{File.basename(name, '.rb')}" }
end

module Rbfam
  def self.connect(config: nil)
    ActiveRecord::Base.establish_connection(config || YAML.load_file(File.join(File.dirname(__FILE__), "..", "db", "config.yml"))["development"])
  end
  
  def self.script(name)
    require "rbfam/scripts/#{File.basename(name, '.rb')}"
  end
end

Rbfam::Family.const_set(:READABLE, JSON.parse(File.read(File.join(File.dirname(__FILE__), "rbfam", "helpers", "simple_names.json"))))