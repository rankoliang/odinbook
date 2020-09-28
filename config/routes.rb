Rails.application.routes.draw do
  get 'users/index'
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  root 'static_pages#index'

  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
