class CreateAreaCities < ActiveRecord::Migration
  def change
    create_table :area_cities do |t|
      t.references       :area_province         #省
    	t.string           :city_name             #市名
    end
  end
end
