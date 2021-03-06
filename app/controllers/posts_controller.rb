class PostsController < ApplicationController
	def index
	  @posts = Post.ct_desc.page(params[:page]).per(5)
	end
  
  def show
    @post = Post.find(params[:id])
    @post.update_attribute(:look_num, @post.look_num + 1)
    @company = @post.company
  end
  
  def search
    area = params[:area]
    k = params[:k]
    filter = {}
    @posts  = nil
    
    
    if k.present?
      #记录热搜词
      k.split(' ').each do|key|
        if current_account.present?
          search_tag = HotSearchTag.find_or_create_by(account_id: current_account.id, name: key)
          search_tag.industry_id = current_account.industry_id
        else
          search_tag = HotSearchTag.find_or_create_by(cookie_id: get_cookie_id, name: key)
        end
        search_tag.search_count = search_tag.search_count.to_i + 1
        search_tag.save
      end
      
      filter = {
        "bool" => {"must" => {"term" => { "area" => area }}}
      } if area.present?
      
      @time = Benchmark.realtime do
        @posts = Post.__elasticsearch__.search "query" => {
          "multi_match" => {
            "query" => k,
            "fields" => [ "title", "address", "sanitize_content" ]
          }
        },
        "filter" => filter,
        "sort" => [],
        "facets" => {},
        highlight: { 
          fields: { 
            title: {"pre_tags" => ["<b>"], "post_tags" => ["</b>"]}, 
            sanitize_content: {"pre_tags" => ["<b>"], "post_tags" => ["</b>"]}, 
            address: {"pre_tags" => ["<b>"], "post_tags" => ["</b>"]} 
          } 
        }
      end
      @posts = @posts.page(params[:page]).per(5)
      @records = @posts.records.includes(:account)
      @posts = @posts.results
    else
      redirect_to posts_path and return
    end
  end

end



