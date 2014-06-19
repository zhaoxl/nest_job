class Account < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  has_attached_file :logo, :styles => { :medium => "300x300>", 
                                        :thumb => "100x100>",
                                        :original => "550x400>"}, 
                                        :default_url => "/images/:style_missing.png",
                                        path: ":rails_root/public/uploads/:class/:attachment/:id/:style/album_cover.:extension",
                                        url: "/uploads/:class/:attachment/:id/:style/album_cover.:extension"
  validates_attachment_content_type :logo, :content_type => /\Aimage\/.*\Z/
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: :create }
  

  #用户类型枚举
  ACCOUNT_TYPE_WORKER = 1 #员工
  ACCOUNT_TYPE_HR    = 2 #HR
  
  belongs_to :company
  has_many :account_resumes
  has_many :posts
  has_many :favorites
  
  scope :by_email, lambda{|email| where(email: email)}
  scope :by_resume_ct_desc, ->{joins("INNER JOIN account_resumes ON accounts.id = account_resumes.account_id").order("account_resumes.created_at DESC")}
  
  
  # 当前简历
  #
  # 作者: 赵晓龙
  # 最后更新时间: 2014-06-07
  #
  # ==== 示例
  # current_account.current_account_resume
  # ==== 返回类型
  # AccountResume
  def current_account_resume
    unless account_resume = account_resumes.first
      account_resume = current_account.account_resumes.build
    end
    return account_resume
  end
  
  
  private
end
