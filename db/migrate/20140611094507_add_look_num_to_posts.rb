class AddLookNumToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :look_num, :integer, default: 0 #查看数
  end
end
