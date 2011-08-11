Vaalit::Application.routes.draw do

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  resource :advocate do
    resource :session
  end

  resources :listings, :only => [] do
    collection do
      get :simple
      get :same_ssn
      get :proportional_order
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
