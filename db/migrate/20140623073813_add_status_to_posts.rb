class AddStatusToPosts < ActiveRecord::Migration
  def up
    add_column :posts, :status, :string
    Post.update_all({status: "status_normal"})
  end
  
  def down
    remove_column :posts, :status
  end
end
