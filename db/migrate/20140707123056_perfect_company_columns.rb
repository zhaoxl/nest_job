class PerfectCompanyColumns < ActiveRecord::Migration
  def change
    remove_column :companies, :account_ids
    add_column :companies, :content, :text
  end
end
