# Tried desperately to monkeypatch the polymorphic connection object,
# but rails lazyloading is too clever by half.

# Think of this module as a hipster, using "case" ironically.

require 'monogamy/mysql'
require 'monogamy/postgresql'
require 'monogamy/sqlite'
require 'active_support/concern'

module Monogamy
  module WithTableLock
    extend ActiveSupport::Concern

    included do
      class << self
        attr_accessor :additional_tables_to_lock
        attr_accessor :additional_models_to_lock
      end
    end

    def with_table_lock(&block)
      self.class.with_table_lock(&block)
    end

    module ClassMethods
      def also_lock_table_names(*table_names)
        (self.additional_tables_to_lock ||= []).concat(table_names)
      end

      def also_lock_models(*models)
        (self.additional_models_to_lock ||= []).concat(models)
      end

      def quoted_table_names_to_lock
        quoted_table_names = [quoted_table_name]
        quoted_table_names += (additional_tables_to_lock || []).collect { |ea| ea.to_s }
        additional_model_classes = (self.additional_models_to_lock ||= []).collect do |ea|
          ea.is_a?(String) || ea.is_a?(Symbol) ? ea.to_s.classify.constantize : ea
        end
        quoted_table_names += additional_model_classes.collect { |ea| ea.quoted_table_name }
      end

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
        adapter.with_table_lock(connection, quoted_table_names_to_lock, &block)
      end
    end
  end
end
