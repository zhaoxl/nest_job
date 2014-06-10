class CreateAccountTags < ActiveRecord::Migration
  def change
    create_table :account_tags do |t|
      t.references :account
      t.references :tag
    end
  end
end
