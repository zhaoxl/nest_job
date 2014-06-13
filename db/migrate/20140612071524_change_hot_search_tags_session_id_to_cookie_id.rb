class ChangeHotSearchTagsSessionIdToCookieId < ActiveRecord::Migration
  def change
    rename_column :hot_search_tags, :session_id, :cookie_id
    change_column :hot_search_tags, :cookie_id, :string
  end
end
