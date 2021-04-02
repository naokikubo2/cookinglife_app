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
    post 'guest_login', to: 'users/sessions#new_guest'
  end

  get "followings/:id", to: "users#followings", as: 'followings'
  get "followers/:id", to: "users#followers", as: 'followers'


  resources :food_records do
    resources :fr_comments, only: %w[create destroy]
    post :favorite
  end
  post "food_records/check_cache_image"
  resources :tags, only: [:index]
  resources :food_shares do
    post :matching
    post :complete
    resources :fs_comments, only: %w[create destroy]
  end
  resources :users, only: %w[index show] do
    post :follow
  end
end
