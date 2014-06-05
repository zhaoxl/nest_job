class PostsController < ApplicationController
	def new
		@post = Post.new
	end
  
  def create
    @post = Post.new(post_create_params)
    @post.save
    flash[:notice] = "保存完成"
    redirect_to :back
  end
  
  private  
  def post_create_params  
    params.require(:post).permit(:title, :area, :price_min, :price_max, :address, :email, :department, :content, :tags)  
  end  
end
