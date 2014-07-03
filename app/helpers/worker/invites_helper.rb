module Worker::InvitesHelper
  STATUS_TITLES = {
    nil: "我申请的面试", 
    "status_apply_normal" => "待HR处理", 
    "status_apply_hr_reject" => "HR拒绝", 
    "status_apply_wait_audition" => "等待面试", 
    "status_apply_audition_passed" => "面试通过", 
    "status_apply_audition_failed" => "面试失败", 
    "status_apply_probation_passed" => "试用成功", 
    "status_apply_probation_failed" => "试用失败"
  }
  #获取工作流当前状态
  def workflow_status_cn(staus)
    Worker::AppliesHelper::STATUS_TITLES[status]
  end
end