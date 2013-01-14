module Monogamy
  module PostgreSQL
    # See http://www.postgresql.org/docs/9.0/static/sql-lock.html
    def self.with_table_lock(connection, quoted_table_names, &block)
      connection.transaction do
        connection.execute("LOCK TABLE #{quoted_table_names.join(",")} IN ACCESS EXCLUSIVE MODE")
        yield
      end
    end
  end
end
