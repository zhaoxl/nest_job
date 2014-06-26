class Workflow < ActiveRecord::Base
  before_create :update_work_class_name
  
  belongs_to :worker, class_name: :account, primary_key: :worker_account_id
  belongs_to :hr, class_name: :account, primary_key: :hr_account_id
  belongs_to :post
  belongs_to :company
  
  scope :order_ct_desc, ->{order("created_at DESC")}
  scope :by_worker_account_id, ->(worker_account_id){where(worker_account_id: worker_account_id)}
  scope :by_hr_account_id, ->(hr_account_id){where(hr_account_id: hr_account_id)}
  scope :by_post_id, ->(post_id){where(post_id: post_id)}
  scope :by_company_id, ->(company_id){where(company_id: company_id)}
  scope :by_status, ->(status){where(status: status)}
  
  private
  #继承给子类的default_scope用的方法，子类会自动执行
  def self.default_scope
    where(work_class_name: self.to_s)
  end
  
  #子类before_save时同步work_class_name属性
  def update_work_class_name
    self.work_class_name = self.class.to_s
  end
end
