class AddEmailToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :email, :string  #公司邮箱
  end
end
