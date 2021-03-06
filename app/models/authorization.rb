class Authorization < ActiveRecord::Base
  belongs_to :account
  
  scope :by_auth, ->(provider, uid){where(provider: provider).where(uid: uid)}
  
  def self.find_or_create_from_auth_hash(auth_hash)
    auth_hash.deep_symbolize_keys!
    provider = auth_hash[:provider]
    params = send("#{provider}_params", auth_hash)
    authorization = find_or_create_by({provider: params[:provider], uid: params[:uid]})
    authorization.assign_attributes(params)
    authorization.save
    authorization
  end
  
  def bind_account(account)
    return false if account.blank?
    
    self.account = account
    self.save
  end
  
  private
  def self.qq_params(auth_hash)
    params = {
      provider: auth_hash[:provider],
      uid: auth_hash[:uid],
      token: auth_hash[:credentials][:token],
      nickname: auth_hash[:info][:nickname],
      logo: auth_hash[:info][:image],
      gender: (auth_hash[:extra][:raw_info][:gender] == "m" ? "男" : "女"),
      province: auth_hash[:extra][:raw_info][:province],
      city: auth_hash[:extra][:raw_info][:city]
    }
  end
  
  def self.weibo_params(auth_hash)
    params = {
      provider: auth_hash[:provider],
      uid: auth_hash[:uid],
      token: auth_hash[:credentials][:token],
      nickname: auth_hash[:info][:nickname],
      logo: auth_hash[:extra][:raw_info][:figureurl_qq_2],
      gender: auth_hash[:extra][:raw_info][:gender],
      province: auth_hash[:extra][:raw_info][:province],
      city: auth_hash[:extra][:raw_info][:city]
    }
  end
end