require "bio"
require "active_support/inflector"

module Rbfam
  Dir[File.join(File.dirname(__FILE__), "/modules/*")].each do |file|
    autoload File.basename(file, ".rb").camelize.to_sym, file
  end
end