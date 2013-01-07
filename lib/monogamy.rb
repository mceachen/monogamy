require 'monogamy/with_table_lock'

module Monogamy
  ActiveSupport.on_load :active_record do
    ActiveRecord::Base.send :extend, Monogamy::WithTableLock
    ActiveRecord::Base.send :include, Monogamy::WithTableLock
  end
end
