class Post < ActiveRecord::Base
  include Elasticsearch::Model
  #include Elasticsearch::Model::Callbacks
  after_save    { logger.debug ["Updating document... ", __elasticsearch__.index_document ].join }
  after_destroy { logger.debug ["Deleting document... ", __elasticsearch__.delete_document].join }
  
  settings index: { number_of_shards: 1 } do
    mappings dynamic: 'false' do
      indexes :title,       analyzer: 'english', index_options: 'offsets'
      indexes :description, analyzer: 'english', index_options: 'offsets'
      indexes :content,     analyzer: 'english', index_options: 'offsets'
      indexes :area,        analyzer: 'english', index_options: 'offsets'
    end
  end
  
end

#Post.mappings.to_hash
## => {
##      :post => {
##        :dynamic => "false",
##        :properties => {
##          :title => {
##            :type          => "string",
##            :analyzer      => "english",
##            :index_options => "offsets"
##          }
##        }
##      }
##    }
#
#Post.settings.to_hash
## { :index => { :number_of_shards => 1 } }
