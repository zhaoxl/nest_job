class ChangeHopeAreaHopeHopePost < ActiveRecord::Migration
  def up
    remove_column :accounts, :hope_city
    add_column :account_resumes, :hope_area, :string  #期望城市
    remove_column :account_resumes, :hope_post
  end
  
  def down
    add_column :accounts, :hope_city, :string  #期望城市
    remove_column :account_resumes, :hope_area
    add_column :account_resumes, :hope_post, :string  #期望职位
  end
end
