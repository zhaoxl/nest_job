class AddSearchNumToHrSearchLogs < ActiveRecord::Migration
  def change
    add_column :hr_search_logs, :search_num, :integer, default: 0 #搜索次数
  end
end
