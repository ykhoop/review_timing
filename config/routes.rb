Rails.application.routes.draw do
  get 'subjects/create'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  # 仮のルーティング
  root 'static_pages#top'
  get 'top', to: 'static_pages#logged_in_top'

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'

  resources :users, only: %i[new create]
  resources :subjects, only: %i[new create]
end
