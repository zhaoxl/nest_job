class CreateAccountRadars < ActiveRecord::Migration
  def change
    create_table :account_radars do |t|
      t.references  :account
      t.string      :idea
      t.boolean     :can_search,                default: true
      t.boolean     :subscribe,                 default: true
      t.integer     :subscribe_frequency,       default: 3
      t.datetime    :start_date
      t.datetime    :end_date
    end
  end
end
