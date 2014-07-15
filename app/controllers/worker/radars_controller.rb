class Worker::RadarsController < ApplicationController
  before_action :authenticate_account!
  include DiversityResult
  
  def save
    begin
      object = current_account.account_radar || current_account.build_account_radar
      unless object.update_attributes(object_create_params)
        raise AjaxException.new(object.errors.messages.inject({}){|hash, item| hash[item[0]] = item[1]*','; hash})
      end

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
  def object_create_params  
    params.require(:account_radar).permit(:status, :can_search, :subscribe, :subscribe_frequency, :start_date, :end_date)  
  end 
end
