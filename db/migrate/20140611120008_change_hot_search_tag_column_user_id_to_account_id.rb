class ChangeHotSearchTagColumnUserIdToAccountId < ActiveRecord::Migration
  def change
    rename_column :hot_search_tags, :user_id, :account_id
  end
end
