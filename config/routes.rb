Rails.application.routes.draw do
  devise_for :users

  root to: "home#index"
  get 'home/index'

  resources :posts do
    resources :comments
    resources :likes, only: [:create, :destroy]
  end

  resources :comments do
    resources :likes, only: [:create, :destroy]
  end

  resource :contacts, only: [:new, :create], path_names: { :new => ''}
end
