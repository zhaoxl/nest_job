class AddAddressAndMaritalStatusToAccountResumes < ActiveRecord::Migration
  def change
    add_column :account_resumes, :marital_status, :string    #婚姻状况
    add_column :account_resumes, :address, :string           #详细住址
  end
end