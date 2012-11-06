module Rbfam
  module CommonHelpers
    def self.included(base)
      base.send(:include, InstanceMethods)
    end
    
    module InstanceMethods
      def bootstrap!(options = {})
        tap { load_entries!(options) }
      end
      
      def entries!(options = {})
        remove_instance_variable(:@parsed_entries)
        entries(options)
      end
    end
  end
end