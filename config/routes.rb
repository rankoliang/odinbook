Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  root 'static_pages#index'

  resources :users, only: %i[index show edit update] do
    member do
      delete 'destroy_attached_avatar', to: 'users#destroy_attached_avatar', as: 'destroy_avatar_attached_to'
    end
    resources :friendships, only: %i[index destroy]

    get 'friends', to: 'friendships#index'
    delete 'remove_friend/:id', to: 'friendships#destroy', as: 'remove_friend'
  end

  post 'friends', to: 'friendships#create'
  delete 'friend_request/:requester_id/:requestee_id', to: 'friend_requests#destroy', as: 'friend_requests'
  get 'sent_requests', to: 'friend_requests#sent_requests'
  post 'add_friend', to: 'friend_requests#create'
  post 'cancel_request', to: 'friend_requests#destroy'
end
