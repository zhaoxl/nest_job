class CreateCompanyScenes < ActiveRecord::Migration
  def change
    create_table :company_scenes do |t|
      t.string      :name
      t.references  :company
      t.attachment  :logo             #logo
    end
  end
end
