class PostsController < ApplicationController
	def index
	  @posts = Post.ct_desc.page(params[:page]).per(5)
	end
  
  def show
    @post = Post.find(params[:id])
    @company = @post.company
  end
  
  def search
    area = params[:area]
    k = params[:k]
    filter = {}
    @posts  = nil
    
    if k.present?
      filter = {
        "term" => {"area" => area}
      } if area.present?
      Post.__elasticsearch__.client = Elasticsearch::Client.new(log: true, trace: true)
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
      
      @posts = @posts.page(params[:page]).per(5)
      @records = @posts.records.includes(:account)
      @posts = @posts.results
    else
      redirect_to posts_path and return
    end
  end
  
  def test
    k = "二海淀的客服进阿是打发"
    Post.__elasticsearch__.client = Elasticsearch::Client.new(log: true, trace: true)
    posts = Post.__elasticsearch__.search "query" => {"bool" =>  {
        "should" =>  [
          { "match" => { "title" =>  k }},
          { "match" => { "address" => k }},
          { "match" => { "content" => k }}
        ],
        "minimum_should_match" =>  1,
        "boost" =>  1.0
      }
    },
    highlight: { fields: { title: {}, content: {}, address: {} } }
    
    posts.results.total

  end
end
