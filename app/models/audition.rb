class Audition < ActiveRecord::Base
  belongs_to :worker, class_name: :account, primary_key: :worker_account_id
  belongs_to :hr, class_name: :account, primary_key: :hr_account_id
  belongs_to :post
  belongs_to :company
  belongs_to :workflow
  
  scope :by_worker_account_id, ->(account_id){where(worker_account_id: account_id)}
  scope :by_status, ->(status){where(status: status)}
  scope :by_workflow_id, ->(workflow_id){where(workflow_id: workflow_id)}
  
  #状态机
  include AASM
  aasm column: :status, skip_validation_on_save: true do
    state :status_normal, initial: true        #正常
  end
  
  #判断是否可以接受面试邀请
  def self.can_audition?(workflow_id, account_id)
    by_workflow_id(workflow_id).by_worker_account_id(account_id).by_status("status_normal").blank?
  end
end
