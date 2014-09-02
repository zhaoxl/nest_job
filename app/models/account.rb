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
  
  ACCOUNT_STATUS = [["正常", "status_normal"], ["已锁定", "status_locked"]]
  
  #状态机
  include AASM
  aasm column: :status, skip_validation_on_save: true do
    state :status_normal, initial: true         #正常
    state :status_locked                        #已锁定
    state :status_virtual                       #虚拟状态

    
    event :set_status_to_normal do
      transitions from: :status_virtual, to: :status_normal
      transitions from: :status_locked, to: :status_normal
    end
    
    event :set_status_to_locked do
      transitions from: :status_normal, to: :status_locked
    end
    
    event :set_status_to_virtual do
      transitions from: :status_normal, to: :status_virtual
      transitions from: :status_locked, to: :status_virtual
    end
  end
  
  
  belongs_to :company
  has_many :account_resumes
  has_many :posts
  has_many :favorites
  has_many :hr_search_logs
  has_many :worker_applies, class_name: WorkflowApply, foreign_key: :worker_account_id
  has_one  :account_radar, class_name: AccountRadar
  has_many :bills
  
  scope :by_ids, ->(ids){where(id: ids)}
  scope :by_status, ->(status){where(status: status)}
  scope :not_status, ->(status){where("status != :status", {status: status})}
  scope :by_email, lambda{|email| where(email: email)}
  scope :by_account_type, lambda{|account_type| where(account_type: account_type)}
  scope :virtual_accounts, ->{by_status("status_virtual")}
  scope :real_accounts, ->{not_status("status_virtual")}
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
      account_resume = self.account_resumes.build
    end
    return account_resume
  end
  
  #可用金币
  def available_gold
    bills.last.try(:after_alance).to_i
  end
  private
end
