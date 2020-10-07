Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  root 'static_pages#index'

  resources :users, only: %i[index show edit update] do
    member do
      delete 'destroy_attached_avatar', to: 'users#destroy_attached_avatar', as: 'destroy_avatar_attached_to'
    end
  end
  post 'add_friend', to: 'friend_requests#create'
  post 'remove_friend', to: 'friend_requests#destroy'

  get 'sent_requests', to: 'friend_requests#sent_requests'
end
