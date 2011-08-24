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

  resources :results, :only => [:index] do
    collection do
      get :deputies
      get :by_votes
      get :by_alliance
    end
  end

  resources :checking_minutes, :only => [:index, :show, :edit, :update]

  resources :listings, :only => [] do
    collection do
      get :simple
      get :same_ssn
      get :showdown
      post :showdown, :action => 'showdown_post'
      get :has_fixes
      post :has_fixes, :action => 'has_fixes_post'
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
