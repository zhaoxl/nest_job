class CreateFinancingStages < ActiveRecord::Migration
  def change
    create_table :financing_stages do |t|
      t.string  :name
    end
  end
end
