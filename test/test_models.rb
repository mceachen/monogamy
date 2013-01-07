ActiveRecord::Schema.define(:version => 0) do
  create_table "tags", :force => true do |t|
    t.string "name"
  end
end

class Tag < ActiveRecord::Base
end
