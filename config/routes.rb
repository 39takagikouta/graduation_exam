Rails.application.routes.draw do
  root 'tops#top'
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  resources :users, only: %i[show]
  resources :preferences, only: [:new, :create, :edit, :update]
  resources :alarms, only: %i[new create edit update destroy] do
    get 'video', to: 'alarms#video', shallow: true
  end
  get 'mypage', to: 'alarms#mypage'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
