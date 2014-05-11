class CreateAreaProvinces < ActiveRecord::Migration
  def change
    create_table :area_provinces do |t|
      t.string           :province_name        #省名
    end
  end
end
