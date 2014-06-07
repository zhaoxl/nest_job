class AccountResume < ActiveRecord::Base
  attr_accessor :tags
  
  has_many :account_resume_tags
end
