class Worker::ResumesController < ApplicationController
  before_action :authenticate_account!
  
  def index
    @account_resume = AccountResume.find_or_create_by(account_id: current_account.id)
    @experiences = @account_resume.account_resume_experiences
    @objects = @account_resume.account_resume_objects
    @educations = @account_resume.account_resume_educations
  end
  
  def ajax_save
    result = {status: "ok"}
    begin
      account_resume = current_account.current_account_resume
      account_resume.assign_attributes(resume_params)
      account_resume.tag_list = account_resume.tags.to_s.split(",")
      unless account_resume.save
        raise AjaxException.new(account_resume.errors.messages.inject({}){|hash, item| hash[item[0]] = item[1]*','; hash})
      end
    rescue Exception => ex
      result = {status: "error", content: ex.message}
      logger.error "accounts_create error log================================================"
      logger.error ex.message
      logger.error ex.backtrace
    end
    render json: result.to_json
  end
  
  private  
  def resume_params  
    params.require(:account_resume).permit(:name, :tel, :email, :birthday, :gender, :education, :price, :marital_status, :address, :hope_salary, :hope_area, :tags)
  end
end
