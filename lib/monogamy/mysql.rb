module Monogamy
  module MySQL
    # See http://dev.mysql.com/doc/refman/5.0/en/lock-tables-and-transactions.html
    def self.with_table_lock(connection, quoted_table_names, &block)
      begin
        lock_tables = quoted_table_names.collect { |ea| "#{ea} WRITE" }.join(",")
        connection.transaction do
          connection.execute("LOCK TABLES #{lock_tables}")
          yield
        end
      ensure
        connection.execute("UNLOCK TABLES")
      end
    end
  end
end
