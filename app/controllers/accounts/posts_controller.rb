class Accounts::PostsController < ApplicationController
  before_action :authenticate_account!
  
  def index
    @posts = current_account.posts.ct_desc.page(params[:id]).per(8)
  end
  
	def new
		@post = Post.new
	end
  
  def create
    post = Post.new(post_create_params)
    post.content = params[:editorValue]
    post.tag_list.add params[:addhopecontenthidden].split(",")
    post.save
    flash[:notice] = "保存完成"
    redirect_to accounts_post_path(post)
  end
  
  def show
    
  end
  
  def ajax_get_tags
    Elasticsearch::Client.new.indices.analyze(index: "index", text: params[:title])
  end
  
  private  
  def post_create_params  
    params.require(:post).permit(:title, :area, :price_min, :price_max, :address, :email, :department, :content)  
  end  
end
