Rails.application.routes.draw do
  get 'mypage', to: 'alarms#mypage'
  resources :alarms, only: %i[new create edit update destroy]
  devise_for :users
  root 'home#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
