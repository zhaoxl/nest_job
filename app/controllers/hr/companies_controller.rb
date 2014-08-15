class Hr::CompaniesController < ApplicationController
  before_action :authenticate_account!
  
  def new
    redirect_to edit_account_registration_path if current_account.company.present?
  end
  
  def create
    company = current_account.build_company(company_create_params)
    unless company.save
      flash[:error] = company.errors.messages.inject({}){|hash, item| hash[item[0]] = item[1]*','; hash}
      redirect_to :back and return
    end
    #保存所在公司
    current_account.save
    
    redirect_to cookies[:goto]||edit_account_registration_path
  end
  
  def update
    company = current_account.company
    company.assign_attributes(company_create_params)
    unless company.save
      flash[:error] = company.errors.messages.inject({}){|hash, item| hash[item[0]] = item[1]*','; hash}
      redirect_to :back and return
    end
    
    redirect_to cookies[:goto]||edit_account_registration_path
  end
  
  private  
  def company_create_params  
    params.require(:company).permit(:name, :home_page, :financing_stage_id, :area, :nature_id, :industry_id, :tel, :email, :content)
  end  
end



