class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string      :name
      t.integer     :price
      t.string      :description
      t.text        :content
      
      t.references  :account
      t.references  :area
      t.references  :company
      t.datetime    :deleted_at
      t.timestamps
    end
  end
end