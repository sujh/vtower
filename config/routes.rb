Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  root to: "home#new"
  resources :plans, only: [:index, :show, :create, :update, :destroy]
  resources :lists, only: [:index, :create, :update, :destroy]
  resources :tasks, only: [:create, :update, :destroy]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
