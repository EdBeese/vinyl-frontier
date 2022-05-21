Rails.application.routes.draw do
  get 'bookings/index'
  get 'bookings/show'
  get 'bookings/new'
  get 'bookings/create'
  get 'bookings/edit'
  get 'bookings/update'
  get 'bookings/destroy'
  devise_for :users
  resources :users, only: [:show]
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :records do
    resources :bookings, only: [ :new, :create ]
  end
  resources :bookings, only: [ :index, :show, :edit, :update, :destroy ] do
    resources :messages, only: [ :new, :create ]
  end
  resources :messages, only: [:index, :show, :destroy]
end
