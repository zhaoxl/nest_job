class Hr::CompanyMembersController < ApplicationController
  before_action :authenticate_account!
  include DiversityResult
  
  def create
    begin
      object = CompanyMember.new(company_member_create_params)
      unless object.save
        raise AjaxException.new(object.errors.messages.inject({}){|hash, item| hash[item[0]] = item[1]*','; hash})
      end
      flash[:success] = "添加成功"
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
  def company_member_create_params  
    params.require(:company_member).permit(:company_id, :name, :post)  
  end 
end
