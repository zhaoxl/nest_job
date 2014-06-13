class Accounts::ResumeExperiencesController < ApplicationController
  before_action :authenticate_account!
  
  def create
    AccountResumeExperience.create(experience_create_params)
    redirect_to :back
  end
  
  private  
  def experience_create_params  
    params.require(:account_resume_experience).permit(:account_resume_id, :company_name, :post, :start_time, :end_time, :description)  
  end 
end
