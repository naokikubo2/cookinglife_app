Rails.application.routes.draw do
  root 'homes#top'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  devise_scope :user do
    get "signup", to: "users/registrations#new"
    get "login", to: "users/sessions#new"
    get "logout", to: "users/sessions#destroy"
  end

  resources :food_records
  resources :tags, only: [:index]
  resources :food_shares do
    post :matching
  end
  resources :users, only: %w[index show] do
    post :follow
  end
end
