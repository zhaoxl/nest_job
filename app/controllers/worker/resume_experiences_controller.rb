class Worker::ResumeExperiencesController < ApplicationController
  before_action :authenticate_account!
  include DiversityResult
  
  def ajax_save
    begin
      object = AccountResumeExperience.find_or_create_by(id: params[:id], account_resume_id: params[:account_resume_experience][:account_resume_id], account_id: current_account.id)      
      unless object.update_attributes(experience_create_params)
        raise AjaxException.new(object.errors.messages.inject({}){|hash, item| hash[item[0]] = item[1]*','; hash})
      end
      
      flash[:ok] = {id: object.id, date: "#{object.start_time.strftime("%Y年%m月")}到#{object.end_time.strftime("%Y年%m月")}"}
    rescue Exception => ex
      flash[:error] = ex.message
      logger.error "ajax_save error log================================================"
      logger.error ex.message
      logger.error ex.backtrace
    end
    
    dr_render do
      redirect_to :back
    end
  end
  
  def destroy
    begin
      object = (AccountResumeExperience.by_account_id(current_account.id).find(params[:id]) rescue raise "内容不存在")
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
  def experience_create_params  
    params.require(:account_resume_experience).permit(:account_resume_id, :company_name, :post, :start_time, :end_time, :description, :salary)  
  end 
end


