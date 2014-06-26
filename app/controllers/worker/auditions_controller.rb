class Worker::AuditionsController < ApplicationController
  before_action :authenticate_account!
  
  def create
    begin
      workflow = (Workflow.unscoped.by_worker_account_id(current_account.id).by_status(["status_invite_audition", "status_apply_audition"]).find(params[:id]) rescue raise "内容不存在")
      object = Audition.new(worker_account_id: current_account.id, workflow_id: workflow.id, hr_account_id: workflow.hr_account_id, post_id: workflow.post_id, company_id: workflow.company_id, price: workflow.price)
      unless object.save
        raise AjaxException.new(object.errors.messages.inject({}){|hash, item| hash[item[0]] = item[1]*','; hash})
      end
    rescue Exception => ex
      flash[:error] = ex.message
      logger.error "ajax_save error log================================================"
      logger.error ex.message
      logger.error ex.backtrace
    end
    redirect_to :back
  end
  
  
end
