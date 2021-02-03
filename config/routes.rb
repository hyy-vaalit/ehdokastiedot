Ehdokastiedot::Application.routes.draw do
  # Devise routes must be on top to get highest priority
  devise_for :admin_users, ActiveAdmin::Devise.config
  devise_for :advocate_users

  ActiveAdmin.routes(self)

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

    resources :candidates, :only => [:index]
    resources :electoral_coalitions, :only => [:index]
    resources :electoral_alliances, :only => [:index]
    resource :danger_zone, :only => [:show]
    resources :candidate_attribute_changes
  end

  resources :listings, :only => [] do
    collection do
      get :simple
      get :same_ssn
      get :lulz
    end
  end

end
