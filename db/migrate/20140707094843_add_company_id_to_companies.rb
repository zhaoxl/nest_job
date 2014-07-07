class AddCompanyIdToCompanies < ActiveRecord::Migration
  def change
    add_column :company_members, :company_id, :integer
  end
end
