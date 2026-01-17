Rails.application.routes.draw do
  # setting home page as login page
  # root "sessions#new"

  get "/home", to: "home#index"
  root "home#index"



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


  # resources :users, only: [ :index, :new, :create, :edit, :update, :destroy ]
  resources :users do
    patch :update_role, on: :member
  end

  # login
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  # signup
  # get  "/signup", to: "users#new"
  # post "/signup", to: "users#create"
  get  "/signup", to: "registrations#new"
  post "/signup", to: "registrations#create"



  # password reset
  get  "/password_resets/new", to: "password_resets#new",    as: :new_password_reset
  post "/password_resets",     to: "password_resets#create", as: :password_resets
  get  "/password_resets/:token/edit", to: "password_resets#edit",   as: :edit_password_reset
  patch "/password_resets/:token",     to: "password_resets#update", as: :password_reset

  # confirm email
  get "/confirm_email", to: "email_confirmations#edit", as: :confirm_email

  # resend email
  get  "/resend_confirmation", to: "email_confirmations#new"
  post "/resend_confirmation", to: "email_confirmations#create"

  # unlock account
  get "/unlock_account", to: "account_unlocks#edit", as: :unlock_account

  # to switch account
  resource :account_switch, only: [ :create ], controller: "accounts/switch"


  # accounts
  resources :accounts, only: [ :new, :create ]

  # invitations
  resources :invitations, only: [ :index, :create ] do
    member do
      get  :accept   # /invitations/:id/accept?token=abc
      post :confirm  # actually performs acceptance
      post :resend
      delete :revoke
    end
  end
end
