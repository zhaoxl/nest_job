class AccountResumeExperience < ActiveRecord::Base
  belongs_to :account_resume
  
  scope :order_start_time_asc, ->{order("start_time ASC")}
  scope :order_start_time_desc, ->{order("start_time DESC")}
  scope :by_account_resume_id, ->(resume_id){where(account_resume_id: resume_id)}
  scope :by_ct_desc, ->{order("created_at DESC")}
  
  after_save :sync_work_start_date #更新所属用户的工作开始时间
  
  #计算工作时间
  def self.work_year(date)
    if date.blank? || !date.is_a?(Date)
      return 0
    end
    
    days = (Date.today - date.to_date).to_f
    year = days / 365
    year = if (year.ceil - year) >= 0.5 
      year.ceil - 0.5
    else 
      year.ceil
    end
  end
  
  private
  
  #更新所属用户的工作开始时间
  def sync_work_start_date
    work_start_date = nil
    
    if earliest = self.class.by_account_resume_id(self.account_resume_id).order_start_time_asc.first
      work_start_date = earliest.start_time
    end
    
    self.account_resume.update_attribute(:work_start_date, work_start_date)
  end
end
