class ChangeHopeAreaHopeHopePost < ActiveRecord::Migration
  def up
    remove_column :accounts, :hope_city
    remove_column :account_resumes, :hope_post
    rename_column :account_resumes, :area, :hope_area
  end
  
  def down
    add_column :accounts, :hope_city, :string  #期望城市
    add_column :account_resumes, :hope_post, :string  #期望职位
    rename_column :account_resumes, :hope_area, :area
  end
end
