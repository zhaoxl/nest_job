class AddSanitizeContentToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :sanitize_content, :text #消毒内容
  end
end
