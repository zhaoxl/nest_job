NestJob::Application.routes.draw do
  captcha_route
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :accounts, controllers: { registrations: "accounts/registrations", sessions: "accounts/sessions" }, :sign_out_via=>[:delete, :get]
  devise_scope :account do
    post "/accounts/registrations/ajax_create" => "accounts/registrations#ajax_create"
    post "/accounts/sessions/ajax_create" => "accounts/sessions#ajax_create"
    #get '/auth/:provider' => 'accounts/sessions#auth'
    get '/auth/:provider/callback' => 'accounts/sessions#auth_create'
  end
    
  get '/' => 'index#index'
  
  
  
  
  resources :help_center
  resources :index do
    collection do
      post :ajax_update_hope
      get :error_notice
      get :about
    end
  end
  
  
  
  
  
  resources :posts do
    collection do
      get :search
    end
  end
  
  
  

  
  resources :hr, controller: "hr/index", only: [] do
    collection do
      get :search
    end
  end
  namespace :hr do
    root to: "index#index"
    get ':id', to: 'index#show', constraints: {id: /\d+/}, shallow: true
    resources :posts
    resources :companies
    resources :company_members
    resources :company_scenes
    resources :applies do
      collection do
        post :accept
        post :reject
      end
    end
    resources :auditions do
      collection do
        post :pass
        post :fail
      end
    end
    resources :probations do
      collection do
        post :pass
        post :fail
      end
    end
  end
  
  
  
  
  namespace :worker do
    resources :resumes do
      collection do
        post :ajax_save
      end
    end
    resources :resume_experiences do
      collection do
        post :ajax_save
      end
    end
    resources :resume_objects do
      collection do
        post :ajax_save
      end
    end
    resources :resume_educations do
      collection do
        post :ajax_save
      end
    end
    resources :radars do
      collection do
        post :save
      end
    end
    resources :applies do
    end
    resources :resume_radars
    resources :invites
    resources :auditions do
    end
  end
  
  
  namespace :accounts do
    resources :profile do
      collection do
        post :ajax_update_logo
      end
    end
    resources :favorites do
      collection do
        post :ajax_create
        post :ajax_destroy
      end
    end
  end
  
  
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
  
end
