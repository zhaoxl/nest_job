class Post < ActiveRecord::Base
  include Elasticsearch::Model
  #include Elasticsearch::Model::Callbacks
  after_save    { logger.debug ["Updating document... ", (__elasticsearch__.index_document rescue "Elasticsearch not connect") ].join }
  after_destroy { logger.debug ["Deleting document... ", (__elasticsearch__.delete_document rescue "Elasticsearch not connect")].join }
  
  settings index: { 
    number_of_shards: 1,
    fulltext: {
      properties: {
        content: {
          include_in_all: true,
          analyzer: "mmseg",
          boost: 8,
          term_vector: "with_positions_offsets",
          type: "string"
        }
      },
      "_all" => {
        analyzer: "mmseg"
      }
    }
  } do
    mappings dynamic: 'false' do
      indexes :title,       analyzer: 'english', index_options: 'offsets'
      indexes :description, analyzer: 'english', index_options: 'offsets'
      indexes :content,     analyzer: 'english', index_options: 'offsets'
      indexes :area,        analyzer: 'english', index_options: 'offsets'
    end
  end
  
  has_attached_file :logo, :processors => [:watermark], :styles => { :medium => "300x300>", 
                                             :thumb => "100x100>",
                                             :original => {:geometry => '550x400>',  
                                                           :watermark_path => "#{Rails.root}/public/watermark.png",#水印图片所在位置  
                                                           :position => 'SouthEast'
                                                         }
                                             }, 
                                             :default_url => "/images/:style_missing.png"
  validates_attachment_content_type :logo, :content_type => /\Aimage\/.*\Z/
  
  attr_accessor :tags
  has_many :post_tags
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
