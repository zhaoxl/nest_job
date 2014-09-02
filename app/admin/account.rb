ActiveAdmin.register_page "accounts_dashboard" do
  menu false
  
  content do |variable|
    div style: "width: 600px; margin: auto auto" do
      ul style: "width: 600px;" do
        li style: "list-style: none; width: 300px; float: left; margin-top: 20px;" do
          "求职者用户：#{Account.by_account_type(Account::ACCOUNT_TYPE_WORKER).count}"
        end
        li style: "list-style: none; width: 300px; float: left; margin-top: 20px;" do
          "招聘方用户：#{Account.by_account_type(Account::ACCOUNT_TYPE_HR).count}"
        end
        li style: "list-style: none; width: 300px; float: left; margin-top: 20px;" do
          "总发起面试数：#{Workflow.count}"
        end
        li style: "list-style: none; width: 300px; float: left; margin-top: 20px;" do
          "总职位数：#{Post.count}"
        end
      end
    end
  end
end
#ActiveAdmin.register_page "accounts_worker" do
#  
#  content do
#    table_for Account.by_account_type(Account::ACCOUNT_TYPE_WORKER) do
#      column :email
#      column :nick_name
#      column :account_type
#      column :status
#      column :last_sign_in_at
#      column :last_sign_in_ip
#      column :created_at
#    end
#  end
#  
#end

ActiveAdmin.register Account, as: "account_workers" do
  menu false
  batch_action :subscribe do |selection|
    render text: "123"
  end
  batch_action :reset_pwd, confirm: "密码将会被重置为123456" do |selection|
    ids = params[:collection_selection]
    Account.by_ids(ids).each do |account|
      account.update_attribute :password, "123456"
    end
    redirect_to :back
  end
  batch_action :unlock do |selection|
    ids = params[:collection_selection]
    Account.by_ids(ids).by_status("status_locked").update_all({status: "status_normal"})
    redirect_to :back
  end
  batch_action :lock do |selection|
    ids = params[:collection_selection]
    Account.by_ids(ids).by_status("status_normal").update_all({status: "status_locked"})
    redirect_to :back
  end
      
  filter :name
  filter :email
  filter :nick_name
  filter :status, as: :select, collection: proc { Account::ACCOUNT_STATUS }
  
  controller do
    def scoped_collection
      if params[:account_type].present?
        end_of_association_chain.by_account_type(params[:account_type]) 
      else
        super
      end
    end
  end
  
  member_action :lock, :method => :put do
    account = Account.find(params[:id])
    if account.status_normal?
      account.set_status_to_locked!
    else
      account.set_status_to_normal!
    end
    redirect_to :back
  end
  
  member_action :update, :method => :put do
    begin
      account = Account.find(params[:id])
      raise "密码不能为空！" if params[:account][:password].blank?
      raise "两次密码输入不一致！" if params[:account][:password] != params[:account][:confirm_password]
      account.password = params[:account][:password]
      account.save
      flash[:notice] = "修改成功"
    rescue Exception => ex
      flash[:notice] = ex.message
      redirect_to :back and return
    end
    redirect_to admin_account_workers_path
  end
    
  index title: "应聘方账号" do
    selectable_column
    id_column
    column :nick_name
    column :email
    column :created_at
    column :last_sign_in_at
    column :worker_apply_count do |account| 
      account.worker_applies.count
    end
    column :status do |account|
      I18n.t("model.account.status.#{account.status}")
    end
    actions name: "操作", defaults: false do |account|
      links = []
      links << link_to("密码重置", edit_resource_path(account)).to_s
      links << link_to("删除", resource_path(account), method: :delete)
      links << link_to(I18n.t("activerecord.models.account.status_action_names.#{account.status}"), lock_admin_account_worker_path(account), method: :put).to_s
      links << link_to("开启订阅", "").to_s
      raw links * " "
    end
  end
  
  form do |f|
    f.inputs :name => "修改密码" do
      f.input :password
      f.input :confirm_password
    end
    f.actions
  end
  
  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end
  
end

ActiveAdmin.register Account, as: "account_hrs" do
  menu false
  
  scope "所有", :all
  scope "虚拟用户", :virtual_accounts
  scope "真实用户", :real_accounts
   

  batch_action :unlock do |selection|
    ids = params[:collection_selection]
    Account.by_ids(ids).by_status("status_locked").update_all({status: "status_normal"})
    redirect_to :back
  end
  batch_action :lock do |selection|
    ids = params[:collection_selection]
    Account.by_ids(ids).by_status("status_normal").update_all({status: "status_locked"})
    redirect_to :back
  end
  batch_action :convert_to_virtual do |selection|
    render text: "123"
  end
  batch_action :convert_to_real do |selection|
    render text: "123"
  end
  
  filter :name
  filter :email
  filter :nick_name
  filter :status, as: :select, collection: proc { Account::ACCOUNT_STATUS }
  
  controller do
    def scoped_collection
      if params[:account_type].present?
        end_of_association_chain.by_account_type(params[:account_type]) 
      else
        super
      end
    end
  end
    
  index title: "招聘方账号" do
    selectable_column
    id_column
    column :nick_name
    column :email
    column :created_at
    column :last_sign_in_at
    column :worker_apply_count do |account| 
      account.worker_applies.count
    end
    column :status do |account|
      I18n.t("model.account.status.#{account.status}")
    end
    actions name: "操作", defaults: false do |account|
      links = []
      links << link_to("密码重置", edit_resource_path(account)).to_s
      links << link_to("删除", resource_path(account), method: :delete)
      links << link_to(I18n.t("activerecord.models.account.status_action_names.#{account.status}"), lock_admin_account_worker_path(account), method: :put).to_s
      raw links * " "
    end
  end
  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end
  
end