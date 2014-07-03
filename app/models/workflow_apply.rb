class WorkflowApply < Workflow
  #状态机
  include AASM
  aasm column: :status, skip_validation_on_save: true do
    state :status_apply_normal, initial: true         #正常
    state :status_apply_hr_reject                     #HR拒绝
    state :status_apply_wait_audition                 #等待面试
    state :status_apply_audition_passed               #面试通过
    state :status_apply_audition_failed               #面试失败
    state :status_apply_probation_passed              #试用成功
    state :status_apply_probation_failed              #试用失败
    
    event :set_status_to_hr_reject do
      transitions from: :status_apply_normal, to: :status_apply_hr_reject
    end
    event :set_status_to_wait_audition do
      transitions from: :status_apply_normal, to: :status_apply_wait_audition
    end
    event :set_status_to_audition_failed do
      transitions from: :status_apply_wait_audition, to: :status_apply_audition_failed
    end
    event :set_status_to_audition_passed do
      transitions from: :status_apply_wait_audition, to: :set_status_to_audition_passed
    end
    event :set_status_to_being_probation do
      transitions from: :set_status_to_audition_passed, to: :status_apply_probation_passed
    end
    event :set_status_to_being_probation do
      transitions from: :set_status_to_audition_passed, to: :status_apply_probation_failed
    end
  end
end

