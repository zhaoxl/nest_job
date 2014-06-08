class Accounts::ProfileController < ApplicationController
  before_action :authenticate_account!
  
  def edit
    
  end
  
  def update
    begin
      if current_account.update_attributes(account_update_params)
        flash[:notice] = "保存成功"
      else
        flash[:error] = current_account.errors
      end
    rescue Exception => ex
      flash[:error] = ex.message
    end
    
    redirect_to :back
  end
  
  def ajax_update_logo
    result = {status: "ok"}
    begin
      current_account.logo = params[:file]
      unless current_account.save
        raise AjaxException.new(current_account.errors.messages.inject({}){|hash, item| hash[item[0]] = item[1]*','; hash})
      end
    rescue Exception => ex
      result = {status: "error", content: ex.message}
      logger.error "ajax_update_logo error log================================================"
      logger.error ex.message
      logger.error ex.backtrace
    end
    render json: result.to_json
  end
  
  private  
  def account_update_params  
    params.require(:account).permit(:nick_name, :email, :company_email, :description)  
  end 
end
