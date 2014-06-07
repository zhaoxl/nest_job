class CreateAccountResumeTags < ActiveRecord::Migration
  def change
    create_table :account_resume_tags do |t|
      t.references :account_resume
      t.references :tag
    end
  end
end
