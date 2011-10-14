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

  namespace :draws, :as => "" do
    get :index, :as => :draws
    resources :coalitions, :as => :coalition_draws
    resources :alliances, :as => :alliance_draws
    resources :candidates, :as => :candidate_draws
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
