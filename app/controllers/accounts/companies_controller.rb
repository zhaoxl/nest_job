class Accounts::CompaniesController < ApplicationController
  before_action :authenticate_account!
  
  def new
    if current_account.company.present?
      flash[:error] = "已经注册过第二步"
      redirect_to index_error_path(goto: "/") and return
    end
  end
  
  def create
    
  end
end
