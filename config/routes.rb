Rails.application.routes.draw do
  get 'users/index'
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  root 'static_pages#index'

  resources :users, only: %i[index show edit update] do
    member do
      delete 'destroy_attached_avatar', to: 'users#destroy_attached_avatar', as: 'destroy_avatar_attached_to'
    end
  end
end
