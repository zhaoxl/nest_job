class CreateAccountResumeRadars < ActiveRecord::Migration
  def change
    create_table :account_resume_radars do |t|
      t.references  :account_resume
      t.string  :status
      t.boolean :be_searched, default: false    #是否可以被搜索
      t.boolean :subscribe,   default: false    #是否订阅
      t.integer :subscribe_frequency            #订阅频率
      t.date    :subscribe_start_date           #订阅开始时间
      t.date    :subscribe_end_date             #订阅结束时间
    end
  end
end
