class Tag < ActiveRecord::Base
  has_many :post_tags
  has_many :account_tags
end
