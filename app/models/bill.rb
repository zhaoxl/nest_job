class Bill < ActiveRecord::Base
  belongs_to :account
  ACTION_TYPE_RECHARGE = 0 #充值
  ACTION_TYPE_CONSUME = 1 #消费
  
  
  #充值
  def self.recharge(account, money)
    available_gold = account.available_gold
    after_alance = available_gold + money
    
    bill = account.bills.build(
      from_account_id: nil, 
      item_name: nil, 
      item_type: nil, 
      item_id: nil, 
      action_type: Bill::ACTION_TYPE_RECHARGE,
      description: "手动充值#{money}元", 
      before_alance: available_gold, 
      after_alance: after_alance, 
      money: money
    )
    bill.save!
    return after_alance
  end
end
