class Accounts::RegistrationsController < Devise::RegistrationsController
  skip_after_filter :reset_last_captcha_code!, :only=>[:ajax_create]
  
  def new
    super
  end
  
  def ajax_create
    result = {status: "ok"}
    begin
      unless captcha_valid? params[:captcha]
        #更新验证码
        reset_last_captcha_code!
        #验证码错误
        raise AjaxException.new({captcha: "验证码错误"})
      end
      resource = Account.new(
        email: params[:account][:email],
        password: params[:account][:password],
        account_type: params[:user_type]
      )
      unless resource.save
        #创建失败
        raise AjaxException.new(resource.errors.messages.inject({}){|hash, item| hash[item[0]] = item[1]*','; hash})
      end
      
      #从cookie取出首页的期望城市和职位标签存入简历
      current_account_resume = resource.current_account_resume
      current_account_resume.hope_area = cookies[:account_hope_area] if cookies[:account_hope_area].present?
      current_account_resume.tag_list.add(cookies[:account_tag_list].split(",")) if cookies[:account_tag_list].present?
      current_account_resume.save
      
      #判断是否是微博绑定用户，如果是则绑定微博账号
      if params[:provider].present? && params[:uid].present?
        if auth = Authorization.by_auth(params[:provider], params[:uid]).first
          auth.bind_account(resource)
        end
      end
      
      #登陆
      sign_in(:account, resource)
      register_step2_path = resource.account_type == Account::ACCOUNT_TYPE_HR ? new_hr_company_path : edit_account_registration_path
      #cookies[:goto]||after_sign_in_path_for(resource)
      result = {status: "ok", content: (register_step2_path)}
    rescue Exception => ex
      result = {status: "error", content: ex.message}
      logger.error "accounts_create error log================================================"
      logger.error ex.message
      logger.error ex.backtrace
    end
    render json: result.to_json
  end
  
  def update
    begin
      if current_account.update_attributes(account_update_params)
        flash[:success] = "保存成功"
      else
        flash[:error] = current_account.errors
      end
    rescue Exception => ex
      flash[:error] = ex.message
    end
    
    redirect_to :back
  end
  
  def ajax_update_logo
    result = {status: "ok"}
    begin
      current_account.logo = params[:file]
      unless current_account.save
        raise AjaxException.new(current_account.errors.messages.inject({}){|hash, item| hash[item[0]] = item[1]*','; hash})
      end
      result[:content] = current_account.logo(:thumb)
    rescue Exception => ex
      result = {status: "error", content: ex.message}
      logger.error "ajax_update_logo error log================================================"
      logger.error ex.message
      logger.error ex.backtrace
    end
    render text: result.to_json
  end
  
  def update_pwd
    begin
      raise "现用密码不正确" unless current_account.valid_password?(params[:account][:current_password])
      current_account.password = params[:account][:password]
      current_account.password_confirmation = params[:account][:password_confirmation]
      raise current_account.errors.messages.values * "," unless current_account.save
      flash[:success] = "修改成功"
    rescue Exception => ex
      flash[:error] = ex.message
      logger.error "ajax_update_logo error log================================================"
      logger.error ex.message
      logger.error ex.backtrace
    end
    redirect_to :back
  end
  
  private  
  def account_update_params  
    params.require(:account).permit(:nick_name, :company_email, :description, :industry_id)  
  end 
end