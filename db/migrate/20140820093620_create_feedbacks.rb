class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.references  :account
      t.string      :content, size: 8000
      t.timestamps
    end
  end
end
