class AddAccountResumeIdToAccountResumeExperiences < ActiveRecord::Migration
  def change
    add_column :account_resume_experiences, :account_resume_id, :integer  #简历id
  end
end
