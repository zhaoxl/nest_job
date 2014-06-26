class Hr::PostsController < ApplicationController
  before_action :authenticate_account!
  
  def index
    @posts = current_account.posts.ct_desc.page(params[:id]).per(8)
  end
  
	def new
    if current_account.company.blank?
      cookies[:goto] = request.original_url
      redirect_to new_accounts_company_path and return
    end
    
		@post = Post.new
	end
  
  def create
    post = Post.new(post_create_params)
    post.account_id = current_account.id
    post.content = params[:editorValue]
    post.tag_list.add params[:addhopecontenthidden].split(",")
    post.sanitize_content = Nokogiri.parse(post.content).text if post.content.present? #去掉html标记的内容取200个字
    #TODO: 公司ID
    post.company_id = Company.last.id
    post.save
    flash[:notice] = "保存完成"
    redirect_to accounts_post_path(post)
  end
  
  def show
    @post = Post.find(params[:id])
    @company = @post.company
  end
  
  def ajax_get_tags
    Elasticsearch::Client.new.indices.analyze(index: "index", text: params[:title])
  end
  
  private  
  def post_create_params  
    params.require(:post).permit(:title, :area, :price_min, :price_max, :address, :email, :department, :content)  
  end  
end
