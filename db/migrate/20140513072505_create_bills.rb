class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|
      t.references  :account          #用户id
      t.integer     :from_account_id  #来向用户id
      t.string      :item_name        #项目名称
      t.string      :item_type        #项目类型
      t.integer     :item_id          #项目id
      t.string      :description      #说明
      t.float       :before_alance    #交易前余额
      t.float       :after_alance     #交易后余额
      t.float       :money            #交易金额
      t.string      :status           #状态
      t.datetime    :created_at       #创建时间
    end
  end
end
