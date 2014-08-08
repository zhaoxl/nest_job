class CreateAccountResumes < ActiveRecord::Migration
  def change
    create_table :account_resumes do |t|
      t.references    :account            #用户id
      t.float         :price              #签约金
      t.string        :title              #简历标题
      t.string        :area               #地区: 北京|海淀
      t.string        :hope_salary        #期望薪资
      t.datetime      :jobd_at            #开始工作时间
      t.string        :education          #学历
      t.timestamps
    end
  end
end
