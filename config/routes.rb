Rails.application.routes.draw do
  resources :posts
  resources :categories do
    get 'posts', to: 'categories#post_list'
  end
  resources :users do
    get 'posts', to: 'users#post_list'
  end
  resources :sessions, only: [:create, :destroy]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
