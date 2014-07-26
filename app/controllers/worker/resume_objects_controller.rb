class Worker::ResumeObjectsController < ApplicationController
  before_action :authenticate_account!
  include DiversityResult
  
  def ajax_save
    begin
      object = AccountResumeObject.find_or_create_by(id: params[:id], account_id: current_account.id)
      unless object.update_attributes(object_create_params)
        raise AjaxException.new(object.errors.messages.inject({}){|hash, item| hash[item[0]] = item[1]*','; hash})
      end

      flash[:success] = {id: object.id, date: "#{object.start_date.strftime("%Y年%m月")}到#{object.end_date.strftime("%Y年%m月")}"}
    rescue Exception => ex
      flash[:error] = ex.message
      logger.error "accounts_create error log================================================"
      logger.error ex.message
      logger.error ex.backtrace
    end
    
    dr_render do
      redirect_to :back
    end
  end
  
  def destroy
    begin
      object = (AccountResumeObject.by_account_id(current_account.id).find(params[:id]) rescue raise "内容不存在")
      object.destroy
    rescue Exception => ex
      flash[:error] = ex.message
      logger.error "destroy error log================================================"
      logger.error ex.message
      logger.error ex.backtrace
    end
    dr_render do
      redirect_to :back
    end
  end
  
  private  
  def object_create_params  
    params.require(:account_resume_object).permit(:account_resume_id, :name, :project_desc, :role_desc, :start_date, :end_date)  
  end 
end


