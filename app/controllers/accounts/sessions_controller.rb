class Accounts::SessionsController < Devise::SessionsController
  
  def new
    super
  end
  
  def create
    super
    #从cookie取出首页关联的标签
    current_account_resume = current_account.current_account_resume
    #如果简历里没有则从cookie取，否则存入cookie
    if current_account_resume.hope_area.blank?
      current_account_resume.hope_area = cookies[:account_hope_area] if cookies[:account_hope_area].present?
      current_account_resume.tag_list.add(cookies[:account_tag_list].split(",")) if cookies[:account_tag_list].present?
      current_account_resume.save
    else
      cookies.permanent[:account_hope_area] = current_account_resume.hope_area
      cookies.permanent[:account_tag_list] = current_account_resume.tag_list * ","
    end
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
          #同步期望城市和简历标签
          #如果简历里没有则从cookie取，否则存入cookie
          current_account_resume = account.current_account_resume
          if current_account_resume.hope_area.blank?
            current_account_resume.hope_area = cookies[:account_hope_area] if cookies[:account_hope_area].present?
            current_account_resume.tag_list.add(cookies[:account_tag_list].split(",")) if cookies[:account_tag_list].present?
            current_account_resume.save
          else
            cookies.permanent[:account_hope_area] = current_account_resume.hope_area
            cookies.permanent[:account_tag_list] = current_account_resume.tag_list * ","
          end
          
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