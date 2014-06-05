class Accounts::SessionsController < Devise::SessionsController
  
  def new
    super
  end
  
  def create
    super
  end
  
  def ajax_create
    result = {status: "ok"}
    begin
      if user = User.by_name(params[:account][:email]).not_by_user_type(User::USERTYPE_ORDINARY_USER).first
        if user.valid_password?(params[:account][:password])
          sign_in(:account, user)
        else
          raise "用户名或密码错误"
        end
      else
        raise "用户名或密码错误"
      end
    rescue Exception => ex
      result = {status: "error", content: ex.message}
    end
    render json: result.to_json
  end
end