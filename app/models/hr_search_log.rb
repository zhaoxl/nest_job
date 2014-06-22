class HrSearchLog < ActiveRecord::Base
  belongs_to :account
  
  scope :by_ct_desc, ->{order("created_at DESC")}
  scope :by_search_num_desc, ->{order("search_num DESC")}
end
