class Hr::AppliesController < ApplicationController
  before_action :authenticate_account!
  include DiversityResult
  
  def index
    @items = WorkflowApply.by_hr_account_id(current_account.id).order_ct_desc
    @items = @items.by_status([:status_apply_normal]) if params[:status] == "status_apply_normal"
    @items = @items.by_status([:status_apply_hr_receive]) if params[:status] == "status_apply_hr_receive"
    @items = @items.by_status([:status_apply_hr_reject]) if params[:status] == "status_apply_hr_reject"
    @items = @items.by_status([:status_wait_audition]) if params[:status] == "status_wait_audition"
    @items = @items.by_status([:status_audition_passed]) if params[:status] == "status_audition_passed"
    @items = @items.by_status([:status_audition_failed]) if params[:status] == "status_audition_failed"
    @items = @items.by_status([:status_probation_passed]) if params[:status] == "status_probation_passed"
    @items = @items.by_status([:status_probation_failed]) if params[:status] == "status_probation_failed"
  end
  
  def receive
    begin
      workflow = (WorkflowApply.find(params[:id]) rescue raise "申请不存在")
      workflow.set_status_to_apply_hr_receive! rescue raise "操作失败"
      flash[:success] = "操作成功"
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
  
  def accept
    begin
      workflow = (WorkflowApply.find(params[:id]) rescue raise "申请不存在")
      workflow.set_status_to_wait_audition! rescue raise "操作失败"
      flash[:success] = "操作成功"
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
  
  def reject
    begin
      workflow = (WorkflowApply.find(params[:id]) rescue raise "申请不存在")
      workflow.set_status_to_apply_hr_reject! rescue raise "操作失败"
      flash[:success] = "操作成功"
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
