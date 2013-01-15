module Monogamy
  module SQLite
    # See http://sqlite.org/lang_transaction.html
    def self.with_table_lock(connection, quoted_table_names, &block)
      if connection.open_transactions > 0
        raise NotImplementedError, "Support for nested transactions within sqlite has not been written"
      end

      begin
        connection.execute("BEGIN EXCLUSIVE TRANSACTION")
      rescue ActiveRecord::StatementInvalid => e
        if e.message.include? "SQLite3::BusyException" # < Rails wraps BusyException in the message (!!!)
          sleep 0.2
          retry
        else
          raise e
        end
      end

      begin
        connection.increment_open_transactions
        yield
        connection.execute("COMMIT TRANSACTION")
      rescue Exception => e
        puts e
        puts e.backtrace.join("\n")
        connection.execute("ROLLBACK TRANSACTION")
      ensure
        connection.decrement_open_transactions
      end
    end
  end
end
