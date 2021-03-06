class Hr::PostsController < ApplicationController
  before_action :authenticate_account!
  include DiversityResult
  
  def index
    @posts = current_account.posts.ct_desc
    @posts = @posts.by_status([:status_normal]) if params[:status] == "status_normal"
    @posts = @posts.by_status([:status_off_shelves]) if params[:status] == "status_off_shelves"
    @posts = @posts.page(params[:id]).per(8)
  end
  
	def new
    flash.clear
    if current_account.company.blank?
      cookies[:goto] = request.original_url
      redirect_to new_hr_company_path and return
    end
    
		@post = Post.new(email: current_account.email)
    @new_posts_for_today = current_account.posts.by_date(Date.today).size
	end
  
  def create
    post = Post.new(post_create_params)
    post.account_id = current_account.id
    post.content = params[:editorValue]
    post.tag_list.add params[:addhopecontenthidden].split(",")
    post.sanitize_content = Nokogiri::HTML(post.content).text if post.content.present? #去掉html标记的内容取200个字
    #TODO: 公司ID
    post.company_id = Company.last.id
    post.save
    flash[:notice] = "保存完成"
    redirect_to hr_post_path(post)
  end
  
  def show
    @post = Post.find(params[:id])
    @company = @post.company
  end
  
  def edit
    @post = Post.find(params[:id])
  end
  
  def destroy
    begin
      post = Post.find(params[:id])
      post.soft_delete!
      flash[:success] = "操作成功"
    rescue Exception => ex
      flash[:error] = ex.message
      logger.error "action error log================================================"
      logger.error ex.message
      logger.error ex.backtrace
    end
    dr_render do
      redirect_to :back
    end
  end
  
  #def ajax_get_tags
  #  Elasticsearch::Client.new.indices.analyze(index: "index", text: params[:title])
  #end
  
  #修改职位上架下架状态
  def set_status
    begin
      post = Post.find(params[:id])
      if post.status_off_shelves?
        post.set_status_to_normal!
      else
        post.set_status_to_off_shelves!
      end
    rescue Exception => ex
      flash[:error] = ex.message
      logger.error "action error log================================================"
      logger.error ex.message
      logger.error ex.backtrace
    end
    dr_render do
      redirect_to :back
    end
  end
  
  private  
  def post_create_params  
    params.require(:post).permit(:title, :area, :price_min, :price_max, :address, :email, :department, :content)  
  end  
end
