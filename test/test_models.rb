ActiveRecord::Schema.define(:version => 0) do
  create_table "tags", :force => true do |t|
    t.string "name"
  end
  create_table "tag_audits", :id => false, :force => true do |t|
    t.string "tag_name"
  end
end

class Tag < ActiveRecord::Base
  also_lock_models :tag_audit
  after_save do
    TagAudit.create do |ea|
      ea.tag_name = name
    end
  end
end

class TagAudit < ActiveRecord::Base
end
