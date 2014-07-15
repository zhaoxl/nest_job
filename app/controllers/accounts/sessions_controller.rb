class Accounts::SessionsController < Devise::SessionsController
  
  def new
    render layout: false
  end
  
  #def create
  #  super
  #  #从cookie取出首页关联的标签
  #  current_account_resume = current_account.current_account_resume
  #  #如果简历里没有则从cookie取，否则存入cookie
  #  if current_account_resume.hope_area.blank?
  #    current_account_resume.hope_area = cookies[:account_hope_area] if cookies[:account_hope_area].present?
  #    current_account_resume.tag_list.add(cookies[:account_tag_list].split(",")) if cookies[:account_tag_list].present?
  #    current_account_resume.save
  #  else
  #    cookies.permanent[:account_hope_area] = current_account_resume.hope_area
  #    cookies.permanent[:account_tag_list] = current_account_resume.tag_list * ","
  #  end
  #end
  
  def ajax_create
    result = {status: "ok"}
    begin
      unless captcha_valid? params[:captcha]
        #验证码错误
        raise AjaxException.new({captcha: "验证码错误"})
      end
      if resource = Account.by_email(params[:account][:email]).first
        if resource.valid_password?(params[:account][:password])
          #同步期望城市和简历标签
          #如果简历里没有则从cookie取，否则存入cookie
          current_account_resume = resource.current_account_resume
          if current_account_resume.hope_area.blank?
            current_account_resume.hope_area = cookies[:account_hope_area] if cookies[:account_hope_area].present?
            current_account_resume.tag_list.add(cookies[:account_tag_list].split(",")) if cookies[:account_tag_list].present?
            current_account_resume.save
          else
            cookies.permanent[:account_hope_area] = current_account_resume.hope_area
            cookies.permanent[:account_tag_list] = current_account_resume.tag_list * ","
          end
          
          #判断是否是微博绑定用户，如果是则绑定微博账号
          if params[:provider].present? && params[:uid].present?
            if auth = Authorization.by_auth(params[:provider], params[:uid]).first
              auth.bind_account(resource)
            end
          end
          
          #登陆
          sign_in(:account, resource)
          result = {status: "ok", content: cookies[:goto]||after_sign_in_path_for(resource)}
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
  
  def auth
    case params[:provider]
    when "weibo"
      client = Weibo2::Client.new
      redirect_to client.auth_code.authorize_url and return
    end
  end
  
  def auth_create
    @authorization = Authorization.find_or_create_from_auth_hash(auth_hash)
    session[:current_auth_id] = @authorization.id
    if @current_account.present?
      #直接绑定
      @authorization.bind_account(@current_account)
      redirect_to (cookies.delete(:goto)||index_index_path) and return
    elsif account = @authorization.account
      #如果用户已经绑定过则直接登录
      sign_in(:account, account)
      redirect_to (cookies.delete(:goto)||index_index_path) and return
    elsif @current_account.blank?
      #没登陆就去注册页
      redirect_to new_account_session_path(provider: @authorization.provider, uid: @authorization.uid) and return
    end
  end
  
  def auth_hash
    request.env['omniauth.auth']
  end
end