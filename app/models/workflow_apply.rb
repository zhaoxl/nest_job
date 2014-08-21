class WorkflowApply < Workflow
  #状态机
  include AASM
  aasm column: :status, skip_validation_on_save: true do
    state :status_apply_normal, initial: true         #正常
    state :status_apply_cancel                        #取消申请
    state :status_apply_hr_receive                    #HR已收到
    state :status_apply_hr_reject                     #HR拒绝

    event :set_status_to_apply_cancel do
      transitions from: :status_apply_normal, to: :status_apply_cancel
    end
    event :set_status_to_apply_hr_receive do
      transitions from: :status_apply_normal, to: :status_apply_hr_receive
    end
    event :set_status_to_apply_hr_reject do
      transitions from: :status_apply_hr_receive, to: :status_apply_hr_reject
    end
  end
end

