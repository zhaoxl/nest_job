class Favorite < ActiveRecord::Base
  belongs_to :post
  belongs_to :account
  
  scope :by_item, ->(item){where(item_type: item.class.to_s).where(item_id: item.id)}
  scope :by_account, ->(account){where(account_id: account)}
  
  def self.favorited?(account, item)
    !!by_item(item).by_account(account).first
  end
end
