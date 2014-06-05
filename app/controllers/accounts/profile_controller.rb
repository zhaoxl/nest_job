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
  
  private  
  def account_update_params  
    params.require(:account).permit(:nick_name, :email, :company_email, :description)  
  end 
end
