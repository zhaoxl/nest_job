class Accounts::AccountPostAppliesController < ApplicationController
  before_action :authenticate_account!
  
  def ajax_create
    result = {status: "ok"}
    begin
      post_id = params[:post_id]
      price = params[:price].to_f
      message = params[:message]

      resource = AccountPostApply.new(post_id: post_id, price: price, message: message)
      unless resource.save
        raise AjaxException.new(resource.errors.messages.inject({}){|hash, item| hash[item[0]] = item[1]*','; hash})
      end
    rescue Exception => ex
      result = {status: "error", content: ex.message}
      logger.error "accounts_create error log================================================"
      logger.error ex.message
      logger.error ex.backtrace
    end
    render json: result.to_json 
  end
end
