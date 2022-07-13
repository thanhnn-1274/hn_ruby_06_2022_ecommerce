Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    namespace :admin do
      resources :categories
      get "/home", to: "static_pages#home"
    end
    root "static_pages#home"
    get "/signup", to: "users#new"
    resources :users, only: %i(create show new)
  end
end
