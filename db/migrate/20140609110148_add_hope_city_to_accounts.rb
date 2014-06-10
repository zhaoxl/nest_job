class AddHopeCityToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :hope_city, :string  #期望城市
  end
end
