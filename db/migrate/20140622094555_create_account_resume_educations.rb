class CreateAccountResumeEducations < ActiveRecord::Migration
  def change
    create_table :account_resume_educations do |t|
      t.string  :name
      t.string  :school
      t.string  :major      #专业
      t.date    :start_date
      t.date    :end_date
    end
  end
end
