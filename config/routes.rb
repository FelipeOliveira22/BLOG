Rails.application.routes.draw do
  root "sessions#new"

  get "signup", to: "users#new"
  post "signup", to: "users#create"

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy" # Corrigido para sessions#destroy

  get "profile", to: "users#profile"
  get "change_password", to: "users#change_password"
  patch "update_password", to: "users#update_password"

  resources :users, only: %i[edit update]

  resources :password_resets, only: [:new, :create, :edit, :update], param: :token

  resources :posts do
    get :search, on: :collection
    post :upload, on: :collection
    post :delete, on: :member
  end

  resources :comments, only: [:create]
end
