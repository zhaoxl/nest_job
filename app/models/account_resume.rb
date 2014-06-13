class AccountResume < ActiveRecord::Base
  attr_accessor :tags
  
  has_many :account_resume_tags
  has_many :account_resume_experiences
  
  #计算工作时间
  def work_year
    unless earliest = account_resume_experiences.order_start_time_desc.first
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
