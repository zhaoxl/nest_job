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
    
  index title: "应聘方账号" do
    selectable_column
    id_column
    column :email
    column :nick_name
    column :account_type
    column :status
    column :last_sign_in_at
    column :last_sign_in_ip
    column :created_at
    actions
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
    column :account_type
    column :status
    column :last_sign_in_at
    column :last_sign_in_ip
    column :created_at
    actions
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