module Rbfam
  class DbConfig
    include Singleton, Virtus.model

    attribute :rfam_file, String, default: ->(_, _) { File.join(File.dirname(__FILE__), "..", "..", "rfam_12.seed.utf8") }
    attribute :env, String, default: "rbfam"
    attribute :config, Hash[String => String], default: ->(_, _) { YAML.load_file(File.join(File.dirname(__FILE__), "..", "..", "db", "config.yml")) }
  
    def scoped_config
      config[env]
    end
  
    def bootstrap!
      load_rakefile
      Rake::Task["db:reset"].invoke
      true
    end
    
    def clear!
      load_rakefile
      Rake::Task["db:drop"].invoke
      true
    end
  
    def connect
      ActiveRecord::Base.establish_connection(scoped_config)
    end
    
    private
    
    def load_rakefile
      Rake.load_rakefile(File.join(File.dirname(__FILE__), "..", "..", "Rakefile"))
    end
  end
end
