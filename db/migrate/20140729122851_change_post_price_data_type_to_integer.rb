class ChangePostPriceDataTypeToInteger < ActiveRecord::Migration
  def change
    change_column :posts, :price_min, :integer
    change_column :posts, :price_max, :integer
  end
end
