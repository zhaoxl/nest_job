class WorkflowInvite < Workflow
  #状态机
  include AASM
  aasm column: :status, skip_validation_on_save: true do
    state :status_invite_normal, initial: true         #正常
    state :status_invite_reject                        #应聘方拒绝
    state :status_invite_wait_audition                 #等待面试
    state :status_invite_audition_passed               #面试成功
    state :status_invite_audition_failed               #面试失败
    state :status_invite_probation_passed              #试用成功
    state :status_invite_probation_failed              #试用失败

    event :set_status_to_audition_reject do
      transitions from: :status_invite_normal, to: :status_invite_reject
    end
    event :set_status_to_wait_audition do
      transitions from: :status_invite_normal, to: :status_invite_wait_audition
    end
  end
end
