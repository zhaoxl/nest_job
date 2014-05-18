class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.integer     :parent_id    #上级id
      t.string      :name         #名称
      t.string      :status       #状态
      t.timestamps
    end
  end
end
