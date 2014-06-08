class Account < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  has_attached_file :logo, :styles => { :medium => "300x300>", 
                                        :thumb => "100x100>",
                                        :original => "550x400>"}, 
                                        :default_url => "/images/:style_missing.png"
  validates_attachment_content_type :logo, :content_type => /\Aimage\/.*\Z/
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: :create }
  
  has_many :account_resumes
  
  scope :by_email, lambda{|email| where(email: email)}
  
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
    self.account_resumes.first
  end
end
