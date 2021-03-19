Rails.application.routes.draw do
  resources :posts do
    resources :comments
  end
  resources :categories do
    get 'posts', to: 'categories#category_posts'
  end
  resources :users do
    get 'posts', to: 'users#author_posts'
  end
  resources :sessions, only: [:create, :destroy]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end