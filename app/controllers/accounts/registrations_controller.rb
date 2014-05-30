class Accounts::RegistrationsController < Devise::RegistrationsController
  
  def new
    super
  end
  
  def create
    unless captcha_valid? params[:captcha]
      #验证码错误
      flash[:error] = "验证码错误"
      redirect_to :back and return
    end
    #登陆
    super
    if resource.new_record?
      #创建失败
      flash[:errors] = resource.errors.messages.values.flatten.uniq
      redirect_to :back and return
    end
    redirect_to root_path
  end
  
  def ajax_create
    result = {status: "ok"}
    begin
      unless captcha_valid? params[:captcha]
        #验证码错误
        raise "验证码错误"
      end
      resource = Account.new(
        email: params[:account][:email],
        password: params[:account][:password]
      )
      
      unless resource.valid?
        #创建失败
        raise resource.errors.messages.values.flatten.uniq * "|"
      end
      sign_in(resource)
    rescue Exception => ex
      result = {status: "error", content: ex.message}
    end
    render json: result.to_json
  end
end