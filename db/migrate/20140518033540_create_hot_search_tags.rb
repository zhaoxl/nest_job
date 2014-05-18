class CreateHotSearchTags < ActiveRecord::Migration
  def change
    create_table :hot_search_tags do |t|
      t.string        :session_id       #session_id
      t.integer       :user_id          #user_id
      t.string        :name             #标签名称
      t.integer       :search_count     #搜索次数
      t.timestamps
    end
  end
end
