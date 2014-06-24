class CreateAccountResumeObjects < ActiveRecord::Migration
  def change
    create_table :account_resume_objects do |t|
      t.references  :account_resume
      t.string      :name
      t.string      :project_desc
      t.string      :role_desc
      t.date        :start_date
      t.date        :end_date
    end
  end
end
