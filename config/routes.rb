Vaalit::Application.routes.draw do

  get "coalitions/index"

  get "alliances/index"

  get "candidates/index"

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  resource :advocate do
    resource :session, :only => [:new, :create, :destroy] do
      get :logout, :action => :destroy
    end
    resources :candidates do
      member do
        post :report_fixes
      end
    end
  end

  resources :configurations, :only => [:index, :update]

  resources :tools, :only => [:index]

  resources :results, :only => [:index, :show]


  resources :checking_minutes, :only => [:index, :show, :edit, :update] do
    collection do
      get :fixes
      get :summary
      post :ready
    end
  end

  namespace :draws do
    match '/', :controller => :index, :action => :index
    match '/notice', :controller => :index, :action => :notice
    resources :coalitions do
      collection do
        post :ready
      end
    end
    resources :alliances do
      collection do
        post :ready
      end
    end
    resources :candidates do
      collection do
        post :ready
      end
    end
  end

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
      post :mark_submitted
    end
  end

end
