module Monogamy
  module MySQL
    # See http://dev.mysql.com/doc/refman/5.0/en/lock-tables-and-transactions.html
    def self.with_table_lock(connection, quoted_table_name, &block)
      begin
        connection.transaction do
          connection.execute("LOCK TABLES #{quoted_table_name} WRITE")
          yield
        end
      ensure
        connection.execute("UNLOCK TABLES")
      end
    end
  end
end
