class CreateAuditions < ActiveRecord::Migration
  def change
    create_table :auditions do |t|
      t.references  :workflow
      t.string      :status
      t.integer     :worker_account_id
      t.integer     :hr_account_id
      t.integer     :post_id
      t.integer     :company_id
      t.integer     :price
      t.string      :message, limit: 2000
      t.string      :reply, limit: 2000
      t.timestamps
    end
  end
end
