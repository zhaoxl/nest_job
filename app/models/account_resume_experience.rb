class AccountResumeExperience < ActiveRecord::Base
  belongs_to :account_resume
  
  scope :order_start_time_desc, ->{order("start_date DESC")}
end
