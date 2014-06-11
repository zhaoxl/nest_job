class Accounts::SessionsController < Devise::SessionsController
  
  def new
    super
  end
  
  def create
    super
    #从cookie取出首页关联的标签
    current_account.hope_city = cookies[:account_hope_city] if cookies[:account_hope_city].present?
    current_account.tag_list.add(cookies[:account_tag_list].split(",")) if cookies[:account_tag_list].present?
    current_account.save
  end
  
  def ajax_create
    result = {status: "ok"}
    begin
      unless captcha_valid? params[:captcha]
        #验证码错误
        raise AjaxException.new({captcha: "验证码错误"})
      end
      if account = Account.by_email(params[:account][:email]).first
        if account.valid_password?(params[:account][:password])
          #从cookie取出首页关联的标签
          account.hope_city = cookies[:account_hope_city] if cookies[:account_hope_city].present?
          account.tag_list.add(cookies[:account_tag_list].split(",")) if cookies[:account_tag_list].present?
          
          #登陆
          sign_in(:account, account)
        else
          raise AjaxException.new({password: "密码错误"})
        end
      else
        raise AjaxException.new({email: "email错误"})
      end
    rescue Exception => ex
      result = {status: "error", content: ex.message}
      logger.error "accounts_create error log================================================"
      logger.error ex.message
      logger.error ex.backtrace
    end
    render json: result.to_json
  end
end