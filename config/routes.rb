Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    namespace :admin do
      resources :categories
      resources :books
      resources :users
      get "/home", to: "static_pages#home"
      root "books#index"
    end
    root "static_pages#home"
    get "/signup", to: "users#new"
    resources :users, only: %i(create show new)
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    resources :books, only: %i(show)
  end
end
