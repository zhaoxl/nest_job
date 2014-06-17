class AddTelToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :tel, :string  #公司联系电话
  end
end
