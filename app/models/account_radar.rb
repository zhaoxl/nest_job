class AccountRadar < ActiveRecord::Base
  IDEA_TYPE_LOOKING_FOR = 0             #目前正在找工作
  IDEA_TYPE_SIX_MONTH_NOT_CHANGE = 1    #半年内无换工作的计划
  IDEA_TYPE_ONE_YEAR_NOT_CHANGE = 2     #一年内无换工作的计划
  IDEA_TYPE_WAIT_AND_SEE = 3            #观望有好的机会再考虑
  IDEA_TYPE_NOT_CHANGE = 4              #我暂时不想找工作
  IDEA_TYPES = [
    ["目前正在找工作", IDEA_TYPE_LOOKING_FOR],
    ["半年内无换工作的计划", IDEA_TYPE_SIX_MONTH_NOT_CHANGE],
    ["一年内无换工作的计划", IDEA_TYPE_ONE_YEAR_NOT_CHANGE],
    ["观望有好的机会再考虑", IDEA_TYPE_WAIT_AND_SEE],
    ["我暂时不想找工作", IDEA_TYPE_NOT_CHANGE],
  ]
  
  SUBSCRIBE_FREQUENCIES = [
    ["3天 / 次", 3],
    ["7天 / 次", 7]
  ]
  belongs_to :account
end
