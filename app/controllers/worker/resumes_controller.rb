class Worker::ResumesController < ApplicationController
  before_action :authenticate_account!
  include DiversityResult
  
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
      logger.error "action error log================================================"
      logger.error ex.message
      logger.error ex.backtrace
    end
    render json: result.to_json
  end
  
  #更新邀约金价格
  def update_price
    begin
      price = params[:price].to_i
      current_account.current_account_resume.update_attribute :price, price
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
  
  private  
  def resume_params  
    params.require(:account_resume).permit(:name, :tel, :email, :birthday, :gender, :education, :price, :marital_status, :address, :hope_salary, :hope_area, :tags)
  end
end
