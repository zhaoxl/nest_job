class AddHopePostToAccountResumes < ActiveRecord::Migration
  def change
    add_column :account_resumes, :hope_post, :string  #期望职位
  end
end
