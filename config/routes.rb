Rails.application.routes.draw do
  get 'users/index'
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  root 'static_pages#index'

  resources :users, only: %i[index show edit update] do
    member do
      delete 'destroy_attached_avatar', to: 'users#destroy_attached_avatar', as: 'destroy_avatar_attached_to'
    end
    post 'add_friend/:friend_id', to: 'friendships#create', as: 'add_friend'
    post 'remove_friend/:friend_id', to: 'friendships#destroy', as: 'remove_friend'
  end
end
