class CreateNatures < ActiveRecord::Migration
  def change
    create_table :natures do |t|
      t.string  :name
    end
  end
end
