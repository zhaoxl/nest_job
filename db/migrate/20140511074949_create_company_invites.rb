class CreateCompanyInvites < ActiveRecord::Migration
  def change
    create_table :company_invites do |t|
      t.references  :company              #被邀请公司id
      t.references  :account              #邀请人id
      t.string      :message, limit: 300  #密语
      t.string      :reply                #回复
      t.string      :status               #状态
      t.datetime    :deleted_at           #删除时间
      t.timestamps
    end
  end
end
