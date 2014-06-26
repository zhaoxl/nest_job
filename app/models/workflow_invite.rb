class WorkflowInvite < Workflow
  #状态机
  include AASM
  aasm column: :status, skip_validation_on_save: true do
    state :status_invite_normal, initial: true        #正常
    state :status_invite_audition                     #等待面试

    #event :set_status_to_normal, after: Proc.new{sync_elasticsearch_index} do
    #  transitions from: :status_off_shelves, to: :status_normal
    #end
    #
    #event :set_status_to_off_shelves, after: Proc.new{sync_elasticsearch_index} do
    #  transitions from: :status_normal, to: :status_off_shelves
    #end
  end
end
