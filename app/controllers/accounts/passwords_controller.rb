class Accounts::PasswordsController < Devise::PasswordsController  
  def create
    
    raise "用户不存在" unless resource = Account.by_email(params[:email]).first
    resource.send_reset_password_instructions
  end
  
  def edit
    super
  end
  
  def update
    super
  end
end