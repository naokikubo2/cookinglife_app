Rails.application.routes.draw do
  get 'food_records/new'
  get 'food_records/show'
  get 'food_records/index'
  get 'food_records/edit'
  root 'homes#top'

  devise_for :users, :controllers => {
    :registrations => 'users/registrations',
    :sessions => 'users/sessions'
  }

  devise_scope :user do
    get "signup", :to => "users/registrations#new"
    get "login", :to => "users/sessions#new"
    get "logout", :to => "users/sessions#destroy"
  end

  resources :food_records
end
