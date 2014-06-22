class AddWorkStartDateToAccountResumes < ActiveRecord::Migration
  def change
    add_column :account_resumes, :work_start_date, :date
  end
end
