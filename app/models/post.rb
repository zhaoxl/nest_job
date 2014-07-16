class Post < ActiveRecord::Base
  include Elasticsearch::Model
  self.__elasticsearch__.client = ELASTICSEARCH_CLIENT
  #include Elasticsearch::Model::Callbacks
  after_save :sync_elasticsearch_index
  after_destroy { logger.debug ["Deleting document... ", (__elasticsearch__.delete_document rescue "Elasticsearch not connect")].join }
  
  settings index: { 
    number_of_shards: 1
  } do
    mappings dynamic: 'false' do
      indexes :title,       analyzer: 'english', index_options: 'offsets'
      indexes :description, analyzer: 'english', index_options: 'offsets'
      indexes :area,        analyzer: 'english', index_options: 'offsets'
      indexes :address,     analyzer: 'english', index_options: 'offsets'
      indexes :sanitize_content,     analyzer: 'english', index_options: 'offsets'
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
  
  #状态机
  include AASM
  aasm column: :status, skip_validation_on_save: true do
    state :status_normal, initial: true        #正常
    state :status_off_shelves                  #下架

    event :set_status_to_normal, after: Proc.new{sync_elasticsearch_index} do
      transitions from: :status_off_shelves, to: :status_normal
    end
    
    event :set_status_to_off_shelves, after: Proc.new{sync_elasticsearch_index} do
      transitions from: :status_normal, to: :status_off_shelves
    end
  end
  
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
    
    return Post.convert_protect_email(self.email)
  end
  
  # 判断是否可以申请职位
  #
  # 作者: 赵晓龙
  # 最后更新时间: 2014-06-17
  #
  # ==== 示例
  # post.can_apply?(123)
  # ==== 返回类型
  # Boolean
  def can_apply?(account_id)
    return false if account_id.blank?
    Workflow.by_worker_account_id(account_id).by_post_id(self.id).not_status("success").blank?
  end
  
  # 转换受保护的email地址
  #
  # 作者: 赵晓龙
  # 最后更新时间: 2014-06-09
  #
  # ==== 示例
  # Post.convert_protect_email("xxxx@bbbb.com")
  # ==== 返回类型
  # String
  def self.convert_protect_email(email)
    email.strip!
    return "" if email.blank?

    if trim_match = /^.{4}(.+)@.+$/.match(email) || trim_match = /^(.+)@.+$/.match(email)
      email.sub(trim_match[1], "**")
    end
  end
  
  
  private
  
  def sync_elasticsearch_index
    if self.status_normal?
      logger.debug ["Updating document... ", (__elasticsearch__.index_document rescue "Elasticsearch not connect") ].join
    else
      logger.debug ["Deleting document... ", (__elasticsearch__.delete_document rescue "Elasticsearch not connect")].join
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
