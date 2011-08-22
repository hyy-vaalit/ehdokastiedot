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

  resources :configurations, :only => [:index, :update]

  resources :tools, :only => [:index]

  resources :listings, :only => [] do
    collection do
      get :simple
      get :same_ssn
      get :result
      get :showdown
      post :showdown, :action => 'showdown_post'
      get :has_fixes
      post :has_fixes, :action => 'has_fixes_post'
      get :lulz
      get :deputies
      get :by_votes
      get :by_alliance
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
