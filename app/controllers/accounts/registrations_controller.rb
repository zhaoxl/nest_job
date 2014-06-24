class Accounts::RegistrationsController < Devise::RegistrationsController
  
  def new
    super
  end
  
  def create
    #unless captcha_valid? params[:captcha]
    #  #验证码错误
    #  flash[:error] = "验证码错误"
    #  redirect_to :back and return
    #end
    ##登陆
    #super
    #if resource.new_record?
    #  #创建失败
    #  flash[:errors] = resource.errors.messages.values.flatten.uniq
    #  redirect_to :back and return
    #end
    #redirect_to root_path
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