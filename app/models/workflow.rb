class Workflow < ActiveRecord::Base
  before_create :update_work_class_name
  
  belongs_to :worker, class_name: Account, foreign_key: :worker_account_id
  belongs_to :hr, class_name: Account, foreign_key: :hr_account_id
  belongs_to :post
  belongs_to :company
  
  scope :order_ct_desc, ->{order("created_at DESC")}
  scope :by_worker_account_id, ->(worker_account_id){where(worker_account_id: worker_account_id)}
  scope :by_hr_account_id, ->(hr_account_id){where(hr_account_id: hr_account_id)}
  scope :by_post_id, ->(post_id){where(post_id: post_id)}
  scope :by_company_id, ->(company_id){where(company_id: company_id)}
  scope :by_status, ->(status){where(status: status)}
  scope :not_status, ->(status){where("status NOT IN (?)", status)}
  
  #状态机
  include AASM
  aasm column: :status, skip_validation_on_save: true do
    state :status_wait_audition                 #等待面试
    state :status_audition_passed               #面试通过
    state :status_audition_failed               #面试失败
    state :status_probation_passed              #试用成功
    state :status_probation_failed              #试用失败
    
    event :set_status_to_wait_audition do
      transitions from: :status_apply_normal, to: :status_wait_audition
      transitions from: :status_invite_normal, to: :status_wait_audition
    end
    event :set_status_to_audition_failed do
      transitions from: :status_wait_audition, to: :status_audition_failed
    end
    event :set_status_to_audition_passed do
      transitions from: :status_wait_audition, to: :status_audition_passed
    end
    event :set_status_to_probation_failed do
      transitions from: :status_audition_passed, to: :status_probation_failed
    end
    event :set_status_to_probation_passed do
      transitions from: :status_audition_passed, to: :status_probation_passed
    end
  end
  
  
  private
  #继承给子类的default_scope用的方法，子类会自动执行
  def self.default_scope
    where(work_class_name: self.to_s) unless self.to_s == "Workflow"
  end
  
  #子类before_save时同步work_class_name属性
  def update_work_class_name
    self.work_class_name = self.class.to_s
  end
end
