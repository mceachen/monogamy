ActiveRecord::Schema.define(:version => 0) do
  create_table "tags", :force => true do |t|
    t.string "name"
  end
  create_table "tag_audits", :id => false, :force => true do |t|
    t.string "tag_name"
  end
  create_table "labels", :id => false, :force => true do |t|
    t.string "name"
  end
end

class Tag < ActiveRecord::Base
  also_lock_models :tag_audit
  also_lock_table_names :labels
  after_save do
    TagAudit.create { |ea| ea.tag_name = name }
    Label.create { |ea| ea.name = name }
  end
end

class TagAudit < ActiveRecord::Base
end

class Label < ActiveRecord::Base
end
