ActiveAdmin.register Account do
  index do
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
