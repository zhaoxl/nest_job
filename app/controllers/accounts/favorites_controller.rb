class Accounts::FavoritesController < ApplicationController
  before_action :authenticate_account!
  
  def index
    @favorites = current_account.favorites.page(params[:page]).per(5)
  end
  
  def ajax_create
    result = {status: "ok"}
    begin
      raise "收藏类型错误" unless ["post", "account_resume"].include?(params[:item_type])
      item = params[:item_type].classify.constantize.find params[:id] rescue raise "内容不存在"
  
      current_account.favorites.create(item_type: item.class.to_s, item_id: item.id) unless current_account.favorites.by_item(item).first
    rescue Exception => ex
      result = {status: "error", content: ex.message}
      logger.error "accounts_create error log================================================"
      logger.error ex.message
      logger.error ex.backtrace
    end
    render json: result.to_json
  end
  
  # ajax取消收藏
  #
  # 作者: 赵晓龙
  # 最后更新时间: 2014-06-18
  #
  # ==== 访问地址
  # /accounts/favorites/ajax_destroy
  # ==== 请求类型
  # post
  # ==== 参数
  # item_type: 条目类型
  # id: 条目id
  # ==== 返回类型
  # {status: "ok"}
  def ajax_destroy
    result = {status: "ok"}
    begin
      if params[:item_type].present?
        item = params[:item_type].classify.constantize.new(id: params[:id])
        current_account.favorites.by_item(item).first.destroy rescue raise "内容不存在"
      else
        current_account.favorites.destroy params[:id] rescue raise "内容不存在"
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

