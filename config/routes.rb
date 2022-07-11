Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    namespace :admin do
      resources :categories
      get "/home", to: "static_pages#home"
    end
  end
end
