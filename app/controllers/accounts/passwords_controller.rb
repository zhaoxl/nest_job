class Accounts::PasswordsController < Devise::PasswordsController  
  layout false
  include DiversityResult
  
  def create
    begin
      @email = params[:email]
      raise "用户不存在" unless resource = Account.by_email(@email).first
      resource.send_reset_password_instructions
    rescue Exception => ex
      flash[:error] = ex.message
      logger.error "action error log================================================"
      logger.error ex.message
      logger.error ex.backtrace
    end
    dr_render do
      if flash[:error].present?
        redirect_to :back
      else
        render :success
      end
    end
  end
  
  def edit
    begin
      @email = params[:email]
      raise "用户不存在" unless resource = Account.by_email(@email).first
      raise I18n.t("errors.messages.expired") unless resource.reset_password_period_valid?
      super
    rescue Exception => ex
      flash[:error] = ex.message
      logger.error "action error log================================================"
      logger.error ex.message
      logger.error ex.backtrace
      redirect_to new_account_password_path and return
    end
  end
  
  def update
    super do
      if resource.errors.messages[:reset_password_token].present?
        flash[:error] = resource.errors.messages[:reset_password_token].join(",")
        redirect_to new_account_password_path and return
      end
    end
  end
end