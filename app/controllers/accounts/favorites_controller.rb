class Accounts::FavoritesController < ApplicationController
  before_action :authenticate_account!
  
  def ajax_create
    result = {status: "ok"}
    begin
      raise "收藏类型错误" unless ["post"].include?(params[:item_type])
      item = params[:item_type].classify.constantize.find params[:id] rescue raise "内容不存在"
  
      current_account.favorites.create(item_type: item.class.to_s, item_id: item.id) unless f = current_account.favorites.by_item(item).first
    rescue Exception => ex
      result = {status: "error", content: ex.message}
      logger.error "accounts_create error log================================================"
      logger.error ex.message
      logger.error ex.backtrace
    end
    render json: result.to_json
  end
  
  def ajax_destroy
    result = {status: "ok"}
    begin
      current_account.favorites.destroy params[:id] rescue raise "内容不存在"
    rescue Exception => ex
      result = {status: "error", content: ex.message}
      logger.error "accounts_create error log================================================"
      logger.error ex.message
      logger.error ex.backtrace
    end
    render json: result.to_json
  end
end

