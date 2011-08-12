Vaalit::Application.routes.draw do

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  resource :advocate do
    resource :session, :only => [:new, :create]
    resources :candidates do
      member do
        post :report_fixes
      end
    end
  end

  resources :listings, :only => [] do
    collection do
      get :simple
      get :same_ssn
      get :proportional_order
      get :showdown
      get :lulz
    end
  end

  resource :voting_area, :only => [:show, :create] do
    member do
      get :login
      post :login, :action => :login_post
      get :logout
      get :mark_ready
    end
  end

end
