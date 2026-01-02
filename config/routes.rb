Rails.application.routes.draw do
  get "sessions/new"
  get "sessions/create"
  get "sessions/destroy"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"


  resources :users, only: [:index, :new, :create, :edit, :update, :destroy]

  # login 
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  # password reset
  get  "/password_resets/new", to: "password_resets#new",    as: :new_password_reset
  post "/password_resets",     to: "password_resets#create", as: :password_resets
  get  "/password_resets/:token/edit", to: "password_resets#edit",   as: :edit_password_reset
  patch "/password_resets/:token",     to: "password_resets#update"


end
