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
        raise AjaxException.new({captcha: "验证码错误"})
      end
      resource = Account.new(
        email: params[:account][:email],
        password: params[:account][:password],
        account_type: params[:account][:user_type]
      )
      unless resource.save
        #创建失败
        raise AjaxException.new(resource.errors.messages.inject({}){|hash, item| hash[item[0]] = item[1]*','; hash})
      end
      
      #从cookie取出首页关联的标签
      resource.hope_area = cookies.delete(:account_hope_area) if cookies[:account_hope_area].present?
      resource.tag_list.add(cookies.delete(:account_tag_list).split(",")) if cookies[:account_tag_list].present?
      
      #登陆
      sign_in(:account, resource)
    rescue Exception => ex
      result = {status: "error", content: ex.message}
      logger.error "accounts_create error log================================================"
      logger.error ex.message
      logger.error ex.backtrace
    end
    render json: result.to_json
  end
end