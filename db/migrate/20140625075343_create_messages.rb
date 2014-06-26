class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer   :sender_account_id
      t.integer   :receiver_account_id
      t.string    :item_type
      t.integer   :item_id
      t.string    :title, limit: 200
      t.string    :description, limit: 2000
      t.text      :content
      t.datetime  :expire_at
      t.string    :status
      t.integer   :message_level
      t.timestamps
    end
  end
end
