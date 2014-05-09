##encoding: UTF-8
namespace :blrs do
  desc "转换地区数据库"
  task :convert_area => :environment do
    begin
      require 'rexml/document'
      include REXML
      input=File.open("#{Rails.root}/lib/tasks/area.xml")
      doc=Document.new(input)
      doc.get_elements("//province").each do |pro|
        province = AreaProvince.create(:province_name => pro.attribute("name").value)
        puts "--"+pro.attribute("name").value
        pro.get_elements("city").each do |ci|
          city = AreaCity.create(:area_province_id => province.id, :city_name => ci.attribute("name").value)
          puts "------"+ci.attribute("name").value
          ci.get_elements("country").each do |co|
            country = AreaCountry.create(:area_city_id => city.id, :country_name => co.attribute("name").value)
            puts "------------"+co.attribute("name").value
          end
        end
      end
    end
  end
end