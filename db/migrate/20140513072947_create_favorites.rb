class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.references  :account          #用户id
      t.string      :item_type        #项目类型
      t.integer     :item_id          #项目id
      t.datetime    :created_at       #创建时间
    end
  end
end
