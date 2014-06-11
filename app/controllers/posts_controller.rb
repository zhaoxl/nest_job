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
        else
          search_tag = HotSearchTag.find_or_create_by(session_id: session["session_id"], name: key)
        end
        search_tag.search_count = search_tag.search_count.to_i + 1
        search_tag.save
      end
      
      filter = {
        "term" => {"area" => area}
      } if area.present?
      Post.__elasticsearch__.client = Elasticsearch::Client.new(log: true, trace: true) if Rails.env.development?
      @time = Benchmark.realtime do
        @posts = Post.__elasticsearch__.search "query" => {"bool" => {"must" => [],"must_not" => [],
              "should" =>  [
                { "match" => { "title" =>  k }},
                { "match" => { "address" => k }},
                { "match" => { "content" => k }}
              ],
              "minimum_should_match" =>  1,
              "boost" =>  1.0
            }
          },
          "filter" => filter,
          "sort" => [],
          "facets" => {},
          highlight: { fields: { title: {}, content: {}, address: {} } }
      end
      @posts = @posts.page(params[:page]).per(5)
      @records = @posts.records.includes(:account)
      @posts = @posts.results
    else
      redirect_to posts_path and return
    end
  end

end
