class CreateCompanyMembers < ActiveRecord::Migration
  def change
    create_table :company_members do |t|
      t.string      :name
      t.attachment  :logo             #logo
      t.string      :post             #职位
      t.timestamps
    end
  end
end
