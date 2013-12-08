require 'erb'
require 'active_record'
require 'monogamy'
require 'database_cleaner'

db_config = File.expand_path("database.yml", File.dirname(__FILE__))
ActiveRecord::Base.configurations = YAML::load(ERB.new(IO.read(db_config)).result)
ActiveRecord::Base.establish_connection(ENV["DB"] || "sqlite")
ActiveRecord::Migration.verbose = false

require 'test_models'
require 'minitest/autorun'

DatabaseCleaner.strategy = :deletion
class MiniTest::Spec
  before do
    DatabaseCleaner.start
  end
  after do
    DatabaseCleaner.clean
  end
end

