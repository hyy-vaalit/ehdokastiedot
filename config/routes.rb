Vaalit::Application.routes.draw do
  get "listings/same_ssn"

  get "listings/simple"

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  resources :listings, :only => [] do
    collection do
      get :simple
    end
  end
end
