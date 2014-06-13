class HotSearchTag < ActiveRecord::Base
  belongs_to :account
  
  scope :by_search_count_desc, ->{order("search_count DESC")}
  scope :by_account_id, ->(account_id){where(account_id: account_id)}
  scope :by_cookie_id, ->(cookie_id){where(cookie_id: cookie_id)}
  scope :by_industry_id, ->(industry_id){where(industry_id: industry_id)}
end
