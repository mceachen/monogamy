module Monogamy
  module SQLite
    # See http://sqlite.org/lang_transaction.html
    def self.with_table_lock(connection, quoted_table_name, &block)
      # I can't get sqlite to insert concurrently, so this is a pass-through.
      yield
    end

    def self.with_table_lock_if_it_really_needed_it_but_it_doesnt(connection, quoted_table_name, &block)
      if connection.open_transactions > 0
        raise NotImplementedError, "Support for nested transactions within sqlite has not been written"
      end

      begin
        connection.execute("BEGIN EXCLUSIVE TRANSACTION")
      rescue Exception => e
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
