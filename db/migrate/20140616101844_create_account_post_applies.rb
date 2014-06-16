class CreateAccountPostApplies < ActiveRecord::Migration
  def change
    create_table :account_post_applies do |t|
      t.references  :account
      t.references  :post
      t.float       :price
      t.string      :message
      t.string      :reply
      t.string      :status
      t.timestamps
    end
  end
end
