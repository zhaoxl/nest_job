class HotSearchTag < ActiveRecord::Base
  belongs_to :account
  
  def hot_tags(session_id, account_id)
    
  end
end
