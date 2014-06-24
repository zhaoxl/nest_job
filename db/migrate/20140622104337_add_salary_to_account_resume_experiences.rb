class AddSalaryToAccountResumeExperiences < ActiveRecord::Migration
  def change
    add_column :account_resume_experiences, :salary, :integer          #薪资
  end
end
