class AddAccountIdToResumeChildren < ActiveRecord::Migration
  def change
    add_column :account_resume_experiences, :account_id, :integer
    add_column :account_resume_objects, :account_id, :integer
    add_column :account_resume_educations, :account_id, :integer
  end
end