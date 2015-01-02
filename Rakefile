require "bundler/gem_tasks"
require "active_record_migrations"
require "rbfam"

ActiveRecordMigrations.load_tasks

ActiveRecord::Base.configurations      = ActiveRecord::Tasks::DatabaseTasks.database_configuration = Rbfam.db.config
ActiveRecord::Tasks::DatabaseTasks.env = Rbfam.db.env
