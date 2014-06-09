class CreateAccountTags < ActiveRecord::Migration
  def change
    create_table :account_tags do |t|

      t.timestamps
    end
  end
end
