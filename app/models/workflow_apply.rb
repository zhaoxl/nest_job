class WorkflowApply < Workflow
  #状态机
  include AASM
  aasm column: :status, skip_validation_on_save: true do
    state :status_apply_normal, initial: true        #正常
    state :status_apply_audition                     #等待面试
  end
end
