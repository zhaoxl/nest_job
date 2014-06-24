class ChangeDescriptionColumnLen < ActiveRecord::Migration
  def up
    change_column :account_resume_experiences, :description, :string, limit: 2000
    change_column :account_resume_objects, :project_desc, :string, limit: 2000
    change_column :account_resume_objects, :role_desc, :string, limit: 2000
  end
  
  def down
    change_column :account_resume_experiences, :description, :string
    change_column :account_resume_objects, :project_desc, :string
    change_column :account_resume_objects, :role_desc, :string
  end
end
