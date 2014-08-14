class Worker::AppliesController < ApplicationController
  before_action :authenticate_account!
  include DiversityResult
  
  def index
    @items = WorkflowApply.by_worker_account_id(current_account.id).order_ct_desc
    @items = @items.by_status([:status_apply_normal]) if params[:status] == "status_apply_normal"
    @items = @items.by_status([:status_apply_hr_receive]) if params[:status] == "status_apply_hr_receive"
    @items = @items.by_status([:status_apply_hr_reject]) if params[:status] == "status_apply_hr_reject"
    @items = @items.by_status([:status_wait_audition]) if params[:status] == "status_wait_audition"
    @items = @items.by_status([:status_audition_passed]) if params[:status] == "status_audition_passed"
    @items = @items.by_status([:status_audition_failed]) if params[:status] == "status_audition_failed"
    @items = @items.by_status([:status_probation_passed]) if params[:status] == "status_probation_passed"
    @items = @items.by_status([:status_probation_failed]) if params[:status] == "status_probation_failed"
  end
  
  def create
    begin
      post_id = params[:post_id]
      price = params[:price].to_f
      message = params[:message]
      
      post = (Post.find(post_id) rescue raise "职位不存在")
      raise AccountResumeIncompleteException, "请先完善简历" unless current_account.current_account_resume.complete?
      raise "不可以重复申请这个职位" unless post.can_apply?(current_account.id)
      resource = WorkflowApply.new(worker_account_id: current_account.id, hr_account_id: post.account_id, post_id: post_id, company_id: post.company_id, price: price, message: message)
      unless resource.save
        raise AjaxException.new(resource.errors.messages.inject({}){|hash, item| hash[item[0]] = item[1]*','; hash})
      end
      flash[:success] = "申请成功"
    rescue AccountResumeIncompleteException => ex
      flash[:redirect] = worker_resumes_path
      flash[:error] = ex.message
      logger.error "action error log================================================"
      logger.error ex.message
      logger.error ex.backtrace
    rescue Exception => ex
      flash[:error] = ex.message
      logger.error "action error log================================================"
      logger.error ex.message
      logger.error ex.backtrace
    end
    dr_render do
      redirect_to :back
    end
  end
end


