Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check

  # Auth
  resource :session, only: [:new, :create, :destroy]
  resources :accounts, only: [:new, :create]

  # Activation keys
  resources :activation_keys, only: [:index, :new, :create, :show, :edit, :update]
  resources :retired_activation_keys, only: [:index]

  # Index lists
  resources :projects, only: [:index, :show]
  resources :libraries, only: [:index, :show]
  resources :namespaces, only: [:index, :show]

  # Static pages
  get "about" => "welcome#about", as: :about

  # Defines the root path route ("/")
  root "welcome#index"
end
