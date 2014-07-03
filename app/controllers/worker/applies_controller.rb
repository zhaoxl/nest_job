class Worker::AppliesController < ApplicationController
  before_action :authenticate_account!
  
  def index
    @items = WorkflowApply.by_worker_account_id(current_account.id).order_ct_desc
    @items = @items.by_status([:status_apply_normal]) if params[:status] == "status_apply_normal"
    @items = @items.by_status([:status_apply_hr_reject]) if params[:status] == "status_apply_hr_reject"
    @items = @items.by_status([:status_apply_wait_audition]) if params[:status] == "status_apply_wait_audition"
    @items = @items.by_status([:status_apply_audition_passed]) if params[:status] == "status_apply_audition_passed"
    @items = @items.by_status([:status_apply_audition_failed]) if params[:status] == "status_apply_audition_failed"
    @items = @items.by_status([:status_apply_probation_passed]) if params[:status] == "status_apply_probation_passed"
    @items = @items.by_status([:status_apply_probation_failed]) if params[:status] == "status_apply_probation_failed"
  end
  
  def ajax_create
    result = {status: "ok"}
    begin
      post_id = params[:post_id]
      price = params[:price].to_f
      message = params[:message]
      
      post = (Post.find(post_id) rescue raise "职位不存在")
      resource = WorkflowApply.new(worker_account_id: current_account.id, hr_account_id: post.account_id, post_id: post_id, company_id: post.company_id, price: price, message: message)
      unless resource.save
        raise AjaxException.new(resource.errors.messages.inject({}){|hash, item| hash[item[0]] = item[1]*','; hash})
      end
    rescue Exception => ex
      result = {status: "error", content: ex.message}
      logger.error "accounts_create error log================================================"
      logger.error ex.message
      logger.error ex.backtrace
    end
    render json: result.to_json 
  end
end


