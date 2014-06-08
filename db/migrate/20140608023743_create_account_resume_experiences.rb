class CreateAccountResumeExperiences < ActiveRecord::Migration
  def change
    create_table :account_resume_experiences do |t|
      t.string  :company_name     #公司名称
      t.string  :post             #职位
      t.datetime  :start_time     #开始时间
      t.datetime  :end_time       #结束时间
      t.string    :description    #描述
      t.timestamps
    end
  end
end
