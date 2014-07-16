class IndexController < ApplicationController
  def index
    if current_account.present? && current_account.account_type == Account::ACCOUNT_TYPE_HR
      redirect_to hr_root_path and return 
    end
    if current_account.present?
      @account_hope_area = current_account.current_account_resume.hope_area
      @account_tags = current_account.current_account_resume.tag_list
    elsif cookies[:account_tag_list].present?
      @account_hope_area = cookies[:account_hope_area]
      @account_tags = cookies[:account_tag_list].to_s.split(",")
    end
    
    @posts = nil
    if @account_tags.present?
      @posts = Post.tagged_with(@account_tags, :any => true).by_look_num_desc
      @posts = @posts.by_area(@account_hope_area) if @account_hope_area.present? && @account_hope_area != "选择城市"
      @posts = @posts.page(params[:page]).per(5)
      if @posts.blank?
        @hot_posts = Post.by_look_num_desc.page(params[:page]).per(5)
      end
    end
  end
  
  def error_notice
    
  end
  
  #更新期望行业（标签）和期望城市
  def ajax_update_hope
    result = {status: "ok"}
    begin
      hope_area = params[:hope_city]
      tagstr = params[:tags]
      if current_account.present? && account_resume = current_account.current_account_resume
          account_resume.hope_area = hope_area
          account_resume.tag_list.add tagstr.split(",")
          account_resume.save
      end
      #同时存入cookie
      cookies.permanent[:account_tag_list] = tagstr
      cookies.permanent[:account_hope_area] = hope_area
    rescue Exception => ex
      result = {status: "error", content: "保存失败"}
      logger.error "accounts_create error log================================================"
      logger.error ex.message
      logger.error ex.backtrace
    end
    render json: result.to_json
  end
  
end


