Rails.application.routes.draw do
  resources :posts
  resources :categories
  resources :users
  resources :sessions, only: [:create, :destroy]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
