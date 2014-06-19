class CreateHrSearchLogs < ActiveRecord::Migration
  def change
    create_table :hr_search_logs do |t|
      t.references  :account
      t.string      :area
      t.string      :post
      t.integer     :year
      t.timestamps
    end
  end
end
