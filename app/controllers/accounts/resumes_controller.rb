class Accounts::ResumesController < ApplicationController
  def index
    unless @account_resume = current_account.current_account_resume
      @account_resume = AccountResume.new
    end
  end
end
