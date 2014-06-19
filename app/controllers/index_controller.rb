class IndexController < ApplicationController
  def index
    if current_account.present?
      @account_tags = current_account.current_account_resume.tag_list
      @account_hope_area = current_account.current_account_resume.hope_area
    elsif cookies[:account_tag_list].present?
      @account_tags = cookies[:account_tag_list]
      @account_hope_area = cookies[:account_hope_area]
    end
    
    @posts = nil
    if @account_tags.present?
      @posts = Post.tagged_with(@account_tags, :any => true).by_look_num_desc
      @posts = @posts.by_area(@account_hope_area) if @account_hope_area.present?
      @posts = @posts.page(params[:page]).per(5)
    end
    
    if @posts
      @hot_posts = Post.by_look_num_desc.page(params[:page]).per(5)
    end
  end
  
  def error_notice
    
  end
  
  #更新期望行业（标签）和期望城市
  def ajax_update_hope
    result = {status: "ok"}
    begin
      hope_area = params[:hope_area]
      tagstr = params[:tags]
      binding.pry
      if current_account.present? && account_resume = current_account.current_account_resume
          account_resume.hope_area = hope_area
          account_resume.tag_list.add tagstr.split(",")
          account_resume.save
      else
        #没登陆存入cookie
        cookies[:account_tag_list] = tagstr
        cookies[:account_hope_area] = hope_area
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


