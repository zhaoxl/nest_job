class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string      :name
      t.string      :home_page
      t.string      :financing_stage  #融资阶段
      t.string      :area             #地区 北京 or 内蒙古|呼和浩特市
      t.attachment  :logo             #logo
      t.references  :nature           #性质
      t.references  :industry         #行业
      t.datetime    :deleted_at       #删除时间
      t.timestamps
    end
  end
end

