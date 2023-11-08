Rails.application.routes.draw do
  devise_for :users

  root to: "home#index"
  get 'home/index'

  resources :posts do
    resources :comments
  end

  resource :contacts, only: [:new, :create], path_names: { :new => ''}
end
