class Accounts::ResumesController < ApplicationController
  before_action :authenticate_account!
  
  def index
    unless @account_resume = current_account.current_account_resume
      @account_resume = AccountResume.new
    end
  end
  
  def create
    begin
      account_resume = current_account.account_resumes.new(post_params)
      unless account_resume.save
        raise account_resume.errors.messages.values.flatten.uniq
      end
      flash[:notice] = "保存成功"
    rescue Exception => ex
      flash[:error] = ex.message
    end
    redirect_to :back
  end
  
  def update
    begin
      account_resume = current_account.current_account_resume
      unless account_resume.update_attributes(post_params)
        raise account_resume.errors.messages.values.flatten.uniq
      end
      flash[:notice] = "保存成功"
    rescue Exception => ex
      flash[:error] = ex.message
    end
    redirect_to :back
  end
  
  private  
  def post_params  
    params.require(:account_resume).permit(:name, :tel, :email, :birthday, :gender, :tags, :area, :hope_salary, :education)  
  end 
end
