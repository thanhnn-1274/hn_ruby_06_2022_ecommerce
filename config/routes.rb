Rails.application.routes.draw do
  namespace :admin do
    get "/home", to: "static_pages#home"
  end
end
