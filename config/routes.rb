require "sidekiq/web"
Rails.application.routes.draw do
  devise_for :users, only: :omniauth_callbacks, controllers: {omniauth_callbacks: "users/omniauth_callbacks"}
  scope "(:locale)", locale: /en|vi/ do
    namespace :admin do
      get "categories/trash", to: "categories#trash"
      resources :categories
      resources :books
      resources :users
      resources :orders
      resources :authors, only: %i(create new)
      get "/home", to: "orders#index"
      get "/statistic", to: "statistic#index"
      root "orders#index"
      resources :categories do
        member do
          get :restore
          delete :really_destroy
        end
      end
      resources :users do
        member do
          patch :ban
        end
      end
    end

    root "books#index"
    devise_for :users, skip: :omniauth_callbacks
    resources :users, except: :index
    resources :books, only: %i(show index)
    resources :carts, only: %i(create index update destroy)
    resources :orders, only: %i(new create index show update)
    resources :comments, only: :create
    mount Sidekiq::Web => "/sidekiq"
  end
  scope module: "api", path: "api" do
    scope module: "v1", path: "v1" do
      scope module: "admin", path: "admin" do
        resources :users
        resources :books
        resources :orders
      end
      post 'auth/login', to: 'auth#sign_in'
    end
  end
end
