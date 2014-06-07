class Accounts::ResumesController < ApplicationController
  before_action :authenticate_account!
  
  def index
    unless @account_resume = current_account.current_account_resume
      @account_resume = AccountResume.new
    end
  end
  
  def create
    
  end
  
  def update
    
  end
end
