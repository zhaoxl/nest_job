class IndexController < ApplicationController
  def index
    if current_account.present?
      @account_tags = current_account.tag_list
      @account_hope_city = current_account.hope_city
    elsif cookies[:account_tag_list].present?
      @account_tags = cookies[:account_tag_list]
      @account_hope_city = cookies[:account_hope_city]
    end
    
    @posts = nil
    if @account_tags.present?
      @posts = Post.tagged_with(@account_tags, :any => true).by_look_num_desc
      @posts = @posts.by_area(@account_hope_city) if @account_hope_city.present?
      @posts = @posts.page(params[:page]).per(5)
    end
    
    if @posts
      @hot_posts = Post.by_look_num_desc.page(params[:page]).per(5)
    end
  end
  
  #更新期望行业（标签）和期望城市
  def ajax_update_hope
    result = {status: "ok"}
    begin
      hope_city = params[:hope_city]
      tagstr = params[:tags]

      if current_account.present?
        current_account.hope_city = hope_city
        current_account.tag_list.add tagstr.split(",")
        current_account.save
      else
        #没登陆存入cookie
        cookies[:account_tag_list] = tagstr
        cookies[:account_hope_city] = hope_city
      end
    rescue Exception => ex
      result = {status: "error", content: "保存失败"}
      logger.error "accounts_create error log================================================"
      logger.error ex.message
      logger.error ex.backtrace
    end
    render json: result.to_json
  end
end


