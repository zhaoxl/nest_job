class Accounts::SessionsController < Devise::SessionsController
  
  def new
    render layout: false
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
    p auth_hash
    binding.pry
    #@authorization = Authorization.find_or_create_from_auth_hash(request.env['omniauth.auth'])
    #session[:current_auth_id] = @authorization.id
    #if @current_user.present?
    #  # 登陆用户视为绑定
    #  begin
    #    cookies[:callback] = nil
    #    @authorization.bind_user(@current_user)
    #    if @callback = request.env['omniauth.params']["callback"]
    #      render layout: false and return
    #    end
    #    return_to = (cookies[:return_to].present? ? cookies[:return_to] : "/tools/#{@authorization.provider}")
    #    cookies[:return_to] = nil
    #    redirect_to return_to
    #  rescue BindUserError
    #    cookies[:callback] = request.env['omniauth.params']["callback"] if request.env['omniauth.params']["callback"]
    #    redirect_to "/tools/#{@authorization.provider}", :flash => { :account_name => @current_user.name }
    #  rescue BindAuthError
    #    cookies[:return_to] = "/tools/#{@authorization.provider}"
    #    cookies[:callback] = request.env['omniauth.params']["callback"] if request.env['omniauth.params']["callback"]
    #    redirect_to "/tools/#{@authorization.provider}", :flash => { :auth_name => @authorization.name }
    #  end
    #elsif !@authorization.deleted and @authorization.user_id.present?
    #  # 未登录用户 微博帐号已经绑定天际帐号
    #  # 产品经理陈昌宏 2012-9-27 说未登录用户，用新浪微博登陆，如果微博帐号已经绑定天际帐号，则把该天际帐号直接设成登陆状态
    #  session[:current_user_id] = @authorization.user_id
    #  @current_account = Account.find(@authorization.user_id) rescue nil
    #  return_url = (cookies[:return_to].present? ? cookies[:return_to] : 'http://www.tianji.com/home')
    #  return_url = return_url =~ /^http:/ ? return_url : "http://www.tianji.com#{return_url}"
    #  redirect_to cas_login_address(@current_account.login_account, @current_account.password_or_crypted_password, return_url)
    #else
    #  # 未登录用户 微博帐号没有绑定天际帐号
    #  redirect_to new_from_auth_account_accounts_path
    #end
  end
  
  def auth_hash
    request.env['omniauth.auth']
  end
end