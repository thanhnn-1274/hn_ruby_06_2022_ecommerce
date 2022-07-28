Rails.application.routes.draw do
  devise_for :users, only: :omniauth_callbacks, controllers: {omniauth_callbacks: "users/omniauth_callbacks"}
  scope "(:locale)", locale: /en|vi/ do
    namespace :admin do
      resources :categories
      resources :books
      resources :users
      resources :orders
      get "/home", to: "orders#index"
      root "orders#index"
    end

    root "books#index"
    devise_for :users, skip: :omniauth_callbacks
    resources :users, except: :index
    resources :books, only: %i(show index)
    resources :carts, only: %i(create index update destroy)
    resources :orders, only: %i(new create index show update)
    resources :comments, only: :create
  end
end
