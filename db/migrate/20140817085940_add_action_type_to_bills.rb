class AddActionTypeToBills < ActiveRecord::Migration
  def change
    add_column :bills, :action_type, :integer
  end
end
