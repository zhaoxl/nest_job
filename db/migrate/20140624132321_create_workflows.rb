class CreateWorkflows < ActiveRecord::Migration
  def change
    create_table :workflows do |t|
      t.integer :account_id
      t.integer :hr_account_id
      t.integer :post_id
      t.integer :company_id
      t.string  :status
      t.string  :flow_class_name
      t.timestamps
    end
  end
end

