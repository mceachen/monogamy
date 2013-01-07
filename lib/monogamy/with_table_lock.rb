# Tried desperately to monkeypatch the polymorphic connection object,
# but rails lazyloading is too clever by half.

# Think of this module as a hipster, using "case" ironically.

require 'monogamy/mysql'
require 'monogamy/postgresql'
require 'monogamy/sqlite'

module Monogamy
  module WithTableLock
    def with_table_lock(&block)
      adapter = case (connection.adapter_name.downcase)
        when "postgresql"
          Monogamy::PostgreSQL
        when "mysql", "mysql2"
          Monogamy::MySQL
        when "sqlite"
          Monogamy::SQLite
        else
          raise NotImplementedError, "Support for #{connection.adapter_name} has not been written"
      end
      adapter.with_table_lock(connection, quoted_table_name, &block)
    end
  end

end
