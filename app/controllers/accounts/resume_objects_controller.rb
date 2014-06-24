class Accounts::ResumeObjectsController < ApplicationController
  before_action :authenticate_account!
  
  def ajax_save
    result = {status: "ok"}
    begin
      object = AccountResumeObject.new(object_create_params)
      unless object.save
        raise AjaxException.new(object.errors.messages.inject({}){|hash, item| hash[item[0]] = item[1]*','; hash})
      end
    rescue Exception => ex
      result = {status: "error", content: ex.message}
      logger.error "accounts_create error log================================================"
      logger.error ex.message
      logger.error ex.backtrace
    end
    render result.to_json
  end
  
  private  
  def object_create_params  
    params.require(:account_resume_object).permit(:account_resume_id, :name, :project_desc, :role_desc, :start_date, :end_date)  
  end 
end
