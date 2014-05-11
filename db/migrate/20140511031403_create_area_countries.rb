class CreateAreaCountries < ActiveRecord::Migration
  def change
    create_table :area_countries do |t|
    	t.references       :area_city               #市
    	t.string           :country_name            #地区名
    end
  end
end
