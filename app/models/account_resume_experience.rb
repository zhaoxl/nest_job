class AccountResumeExperience < ActiveRecord::Base
  belongs_to :account_resume
  
  scope :order_start_time_asc, ->{order("start_time ASC")}
end
