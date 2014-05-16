class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string      :title
      t.integer     :price
      t.string      :description
      t.text        :content
      t.string      :area
      
      t.references  :account
      t.references  :company
      t.datetime    :deleted_at
      t.timestamps
    end
  end
end