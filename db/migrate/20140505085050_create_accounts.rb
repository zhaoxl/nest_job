class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string      :email
      t.string      :password
      t.string      :nick_name
      t.attachment  :logo                                   #logo
      t.integer     :account_type,  default: 0
      t.string      :status,        default: "status_normal"
      t.references  :company
      t.datetime    :deleted_at
      t.datetime    :created_at
    end
  end
end
