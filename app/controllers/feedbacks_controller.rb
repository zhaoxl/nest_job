class FeedbacksController < ApplicationController
  layout false
  
  def create
    begin
      feedback = Feedback.new(feedback_params)
      raise "内容为空" if feedback.content.blank?
      feedback.account = current_account.try(:id)
      feedback.save
      flash[:success] = "反馈成功"
    rescue Exception => ex
      flash[:error] = ex.message
    end
    redirect_to :back
  end
  
  
  private  
  def feedback_params  
    params.require(:feedback).permit(:content)
  end
end
