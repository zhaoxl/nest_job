class AddIndustryIdToModels < ActiveRecord::Migration
  def change
    add_column :accounts, :industry_id, :integer
    add_column :hot_search_tags, :industry_id, :integer
    add_column :posts, :industry_id, :integer
  end
end
