class AddDescriptionAndCompanyEmailToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :description, :string
    add_column :accounts, :company_email, :string
  end
end
