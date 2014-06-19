class AccountResume < ActiveRecord::Base
  attr_accessor :tags
  
  has_many :account_resume_experiences
  #tag插件
  acts_as_taggable
  
  scope :by_ct_desc, ->{order("created_at DESC")}
  
  #计算工作时间
  def work_year
    unless earliest = account_resume_experiences.order_start_time_asc.first
      return 0
    end
    
    if earliest.start_time.blank?
      return 0
    end
    
    days = (Date.today - earliest.start_time.to_date).to_f
    year = days / 365
    year = if (year.ceil - year) >= 0.5 
      year.ceil - 0.5
    else 
      year.ceil
    end
  end
end
