class AccountTag < ActiveRecord::Base
  belongs_to :tag
  belongs_to :account
end
