class ChangeAccountResumesColumns < ActiveRecord::Migration
  def self.up
    remove_column :account_resumes, :jobd_at
  end
  
  def self.down
    add_column :account_resumes, :jobd_at, :datetime
  end
end
