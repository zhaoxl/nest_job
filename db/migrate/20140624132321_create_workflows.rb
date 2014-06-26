class CreateWorkflows < ActiveRecord::Migration
  def change
    create_table :workflows do |t|
      t.integer :worker_account_id
      t.integer :hr_account_id
      t.integer :post_id
      t.integer :company_id
      t.string  :status
      t.string  :work_class_name
      t.integer :price
      t.string  :message, limit: 2000
      t.string  :reply, limit: 2000
      t.timestamps
    end
  end
end

