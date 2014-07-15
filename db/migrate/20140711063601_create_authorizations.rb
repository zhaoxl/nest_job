class CreateAuthorizations < ActiveRecord::Migration
  def change
    create_table :authorizations do |t|
      t.references  :account
      t.string  :provider
      t.string  :uid
      t.string  :token
      t.string  :nickname
      t.string  :logo
      t.string  :gender
      t.string  :province
      t.string  :city
    end
  end
end
