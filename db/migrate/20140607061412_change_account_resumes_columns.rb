class ChangeAccountResumesColumns < ActiveRecord::Migration
  def self.up
    remove_column :account_resumes, :jobd_at
    add_column :account_resumes, :name, :string       #姓名
    add_column :account_resumes, :tel, :string        #手机
    add_column :account_resumes, :email, :string      #email
    add_column :account_resumes, :birthday, :datetime #生日
    add_column :account_resumes, :gender, :integer    #性别
  end
  
  def self.down
    add_column :account_resumes, :jobd_at, :datetime
    remove_column :account_resumes, :name
    remove_column :account_resumes, :tel
    remove_column :account_resumes, :email
    remove_column :account_resumes, :birthday
    remove_column :account_resumes, :gender
  end
end
