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
      ensure_action("Are you sure you'd like to completely rebuild the database? This takes around 10 minutes.") do
        Rake::Task["db:reset"].invoke
      end
    end
    
    def seed!
      ensure_action("Are you sure you'd like to re-seed the database? This is faster than bootstrap!, and won't delete data.") do
        Rake::Task["db:seed"].invoke
      end
    end
    
    def clear!
      ensure_action("Are you sure you'd like drop the database? This can't be un-done.") do
        Rake::Task["db:drop"].invoke
      end
    end
  
    def connect
      ActiveRecord::Base.establish_connection(scoped_config)
    end
    
    private
    
    def ensure_action(string, &block)
      puts "#{string} (y/n)"
      response = gets.chomp.downcase
      if response == ?y
        load_rakefile
        yield block
        true
      else 
        puts "Bailing, no changes were made."
        false
      end
    end
    
    def load_rakefile
      Rake.load_rakefile(File.join(File.dirname(__FILE__), "..", "..", "Rakefile"))
    end
  end
end
