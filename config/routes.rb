Rails.application.routes.draw do
  devise_for :users

  devise_scope :user do
    get 'sign_in', to: 'devise/sessions#new'
    get 'sign_up', to: 'devise/registrations#new'
  end
  root 'static_pages#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
