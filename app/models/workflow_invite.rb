class WorkflowInvite < Workflow
  #状态机
  include AASM
  aasm column: :status, skip_validation_on_save: true do
    state :status_invite_normal, initial: true         #正常
    state :status_invite_wait_audition                 #等待面试
    state :status_invite_being_audition                #正在面试

    event :set_status_to_wait_audition do
      transitions from: :status_invite_normal, to: :status_invite_wait_audition
    end
    event :set_status_to_being_audition do
      transitions from: :status_invite_wait_audition, to: :status_invite_being_audition
    end
  end
end
