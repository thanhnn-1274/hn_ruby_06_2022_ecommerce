Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    namespace :admin do
      resources :categories
      resources :books
      resources :users
      resources :orders
      get "/home", to: "orders#index"
      root "orders#index"
    end

    root "static_pages#home"
    get "/my-order", to: "orders#sort"
    get "/signup", to: "users#new"
    resources :users, except: :index
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    get "/books", to: "books#sort"
    resources :books, :categories, only: %i(show)
    resources :carts, only: %i(create index update destroy)
    resources :orders, only: %i(new create index show update)
    resources :comments, only: :create
  end
end
