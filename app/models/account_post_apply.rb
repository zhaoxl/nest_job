class AccountPostApply < ActiveRecord::Base
  belongs_to :account
  belongs_to :post
  
  scope :by_account_id, ->(account_id){where(account_id: account_id)}
  scope :by_post_id, ->(post_id){where(post_id: post_id)}
end
