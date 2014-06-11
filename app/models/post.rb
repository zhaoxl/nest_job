class Post < ActiveRecord::Base
  include Elasticsearch::Model
  #include Elasticsearch::Model::Callbacks
  after_save    { logger.debug ["Updating document... ", (__elasticsearch__.index_document rescue "Elasticsearch not connect") ].join }
  after_destroy { logger.debug ["Deleting document... ", (__elasticsearch__.delete_document rescue "Elasticsearch not connect")].join }
  
  settings index: { 
    number_of_shards: 1
  } do
    mappings dynamic: 'false' do
      indexes :title,       analyzer: 'english', index_options: 'offsets'
      indexes :description, analyzer: 'english', index_options: 'offsets'
      indexes :area,        analyzer: 'english', index_options: 'offsets'
      indexes :address,     analyzer: 'english', index_options: 'offsets'
      indexes :content,     analyzer: 'english', index_options: 'offsets'
    end
  end
  
  #has_attached_file :logo, :processors => [:watermark], :styles => { :medium => "300x300>", 
  #                                           :thumb => "100x100>",
  #                                           :original => {:geometry => '550x400>',  
  #                                                         :watermark_path => "#{Rails.root}/public/watermark.png",#水印图片所在位置  
  #                                                         :position => 'SouthEast'
  #                                                       }
  #                                           }, 
  #                                           :default_url => "/images/:style_missing.png"
  #validates_attachment_content_type :logo, :content_type => /\Aimage\/.*\Z/
  
  #tag插件
  acts_as_taggable
  
  belongs_to :account
  belongs_to :company
  
  scope :ct_desc, ->{order("created_at DESC")}
  scope :by_area, ->(area){where(area: area)}
  scope :by_look_num_desc, ->{order("look_num DESC")}
  
  
  # 受保护的email地址
  #
  # 作者: 赵晓龙
  # 最后更新时间: 2014-06-09
  #
  # ==== 示例
  # post.protect_email
  # ==== 返回类型
  # String
  def protect_email
    return "" if self.email.blank?
    
    return self.email.sub(/^.{4}(.+)@.+$/.match(email)[1], "**")
  end
  
  private
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
