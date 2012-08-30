Vaalit::Application.routes.draw do

  devise_for :advocate_users

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  root :to => "public#index"
  get "/advocates", :to => "public#index", :as => :advocate_index

  namespace :advocates do
    get :index, :as => :advocates
    resources :alliances do
      resources :candidates
    end
  end

  namespace :manage do
    get "configuration", :to => "configurations#index"
    resource :configuration, :only => [:index, :update, :edit] do
      put :disable_advocate_login, :to => "configurations#disable_advocate_login"
      put :enable_advocate_login,  :to => "configurations#enable_advocate_login"
    end

    resource :danger_zone, :only => [:show]

    resources :candidate_attribute_changes
  end

  resources :results, :only => [:index, :show]

  namespace :draws, :as => "" do
    get :index, :as => :draws
    resources :coalitions, :as => :coalition_draws
    resources :alliances, :as => :alliance_draws
    resources :candidates, :as => :candidate_draws
    post :candidate_draws_ready
    post :alliance_draws_ready
    post :coalition_draws_ready
  end

  resources :checking_minutes, :only => [:index, :show, :edit, :update] do
    collection do
      get :fixes
      get :summary
      post :ready
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
