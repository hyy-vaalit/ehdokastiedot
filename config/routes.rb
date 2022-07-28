Rails.application.routes.draw do
  # Devise routes must be on top to get highest priority
  devise_for :admin_users, ActiveAdmin::Devise.config

  ActiveAdmin.routes(self)

  namespace :haka do
    get "auth/sign_out", to: "/haka_auth#destroy"
    get 'auth/new', to: "/haka_auth#new"
    get "auth/consume", to: "/haka_auth#consume"
    post "auth/consume", to: "/haka_auth#consume"

    if Vaalit::Config.fake_auth_enabled?
      post "auth/fake_authentication", to: "/haka_auth#create_fake_authentication"
    end
  end

  root :to => "public#index"

  get "/advocates", :to => "public#index", :as => :advocate_index

  namespace :advocates do
    get :index, :as => :advocates
    resources :alliances do
      resources :candidates
    end
  end

  namespace :registrations do
    root to: "/registrations#index"

    resource :candidate do
      post :cancel, to: "candidates#cancel"
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
    resource :danger_zone, :only => [:show] do
      post :give_candidate_numbers, to: "give_candidate_numbers"
    end
    resources :candidate_attribute_changes
  end

  resources :listings, :only => [] do
    collection do
      get :simple
      get :lulz
    end
  end
end
