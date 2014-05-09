class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string      :name
      t.string      :home_page
      t.string      :financing_stage  #融资阶段
      t.attachment  :logo             #logo
      t.datetime    :deleted_at
      t.references  :account
      t.references  :nature           #性质
      t.references  :industry         #行业
      t.references  :area
      t.timestamps
    end
  end
end

