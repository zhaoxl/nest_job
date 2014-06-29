class WorkflowApply < Workflow
  #状态机
  include AASM
  aasm column: :status, skip_validation_on_save: true do
    state :status_apply_normal, initial: true         #正常
    state :status_apply_hr_reject                     #HR拒绝
    state :status_apply_wait_audition                 #等待面试
    state :status_apply_being_audition                #正在面试
    state :status_apply_audition_passed               #面试通过
    
    event :set_status_to_wait_audition do
      transitions from: :status_apply_normal, to: :status_apply_wait_audition
    end
    event :set_status_to_wait_audition do
      transitions from: :status_apply_normal, to: :status_apply_hr_reject
    end
    event :set_status_to_being_audition do
      transitions from: :status_apply_wait_audition, to: :status_apply_being_audition
    end
    event :set_status_to_audition_passed do
      transitions from: :status_apply_being_audition, to: :set_status_to_audition_passed
    end
  end
end

