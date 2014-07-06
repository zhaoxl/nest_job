class Hr::ProbationsController < ApplicationController
  before_action :authenticate_account!
  include DiversityResult
  
  def pass
    begin
      workflow = (Workflow.unscoped.find(params[:id]) rescue raise "试用不存在")
      workflow.set_status_to_probation_passed! rescue raise "操作失败"
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
  
  def fail
    begin
      workflow = (Workflow.unscoped.find(params[:id]) rescue raise "试用不存在")
      workflow.set_status_to_probation_failed! rescue raise "操作失败"
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
