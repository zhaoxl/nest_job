class AccountResume < ActiveRecord::Base
  attr_accessor :tags
  
  belongs_to :account
  has_many :account_resume_experiences
  has_many :account_resume_objects
  has_many :account_resume_educations
  has_many :account_resume_radars
  #tag插件
  acts_as_taggable
  
  MARITAL_STSTUS_ENUM = [["未婚", 0], ["已婚", 1], ["保密", 2]]
  
  scope :by_ct_desc, ->{order("created_at DESC")}
  scope :by_area, ->(area){where(hope_area: area)}
  scope :by_work_year_gte, ->(year){
    date = Date.today - year
    where("TO_DAYS(work_start_date) >= TO_DAYS(?)", date)
  } #工作时间大于等于多少年
  
  
  def self.search(tags, area, year)
    tags = tags.split(/[,\s]/) unless tags.is_a?(Array)
    
    resumes = by_ct_desc
    resumes = resumes.tagged_with(tags, :any => true) if tags.present?
    resumes = resumes.by_area(area) if area.present?
    resumes = resumes.by_work_year_gte(year.to_i) if year.present?
    
    return resumes
  end
  
  def age
    today = Date.today
    dob = self.birthday
    
    age = today.year - dob.year
    age -= 1 if dob.strftime("%m%d").to_i > today.strftime("%m%d").to_i
    age
  end
  
end
