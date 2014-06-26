class AccountResumeObject < ActiveRecord::Base
  belongs_to :account_resume
  
  scope :order_start_time_asc, ->{order("start_time ASC")}
  scope :order_start_time_desc, ->{order("start_time DESC")}
  scope :by_account_resume_id, ->(resume_id){where(account_resume_id: resume_id)}
  scope :by_account_id, ->(account_id){where(account_id: account_id)}
  scope :by_ct_desc, ->{order("created_at DESC")}
end
