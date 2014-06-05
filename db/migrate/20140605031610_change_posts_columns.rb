class ChangePostsColumns < ActiveRecord::Migration
  def self.up
    remove_column :posts, :price
    add_column :posts, :price_min, :float, default: 0       #工资区间
    add_column :posts, :price_max, :float, default: 0       #工资区间
    add_column :posts, :address, :string                    #详细地址
    add_column :posts, :department, :string                 #部门
    add_column :posts, :email, :string                      #接收邮件email
  end
  
  def self.down
    add_column :posts, :price, :float
    remove_column :posts, :price_min
    remove_column :posts, :price_max
    remove_column :posts, :address
    remove_column :posts, :department
    remove_column :posts, :email
  end
end
