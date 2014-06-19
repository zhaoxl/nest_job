class Accounts::CompaniesController < ApplicationController
  before_action :authenticate_account!
  
  def new
    if current_account.company.present?
      flash[:error] = "已经完善过公司信息"
      cookies[:goto] ||= "/"
      redirect_to error_notice_index_index_path and return
    end
  end
  
  def create
    company = current_account.build_company(company_create_params)
    unless company.save
      flash[:error] = company.errors.messages.inject({}){|hash, item| hash[item[0]] = item[1]*','; hash}
      redirect_to :back and return
    end
    #保存所在公司
    current_account.save
    
    redirect_to cookies[:goto]||accounts_profile_index_path
  end
  
  private  
  def company_create_params  
    params.require(:company).permit()  
  end  
end
