class CreateTalks < ActiveRecord::Migration
  def change
    create_table :talks do |t|
      t.integer     :talk_type            #邀请类型
      t.string      :status               #状态
      t.references  :account              #发送者
      t.integer     :recipient_id         #接受者
      t.integer     :up_id                #上层id
      t.string      :message, limit: 300  #密语
      t.string      :reply                #回复
      t.datetime    :deleted_at           #删除时间
      t.timestamps
    end
  end
end
