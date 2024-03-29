Rails.application.routes.draw do
  root 'static_pages#top'

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'

  get 'terms', to: 'documents#terms'
  get 'privacy_policy', to: 'documents#privacy_policy'

  resources :users, only: %i[new create] do
    collection do
      get 'profile', to: 'profiles#edit'
      patch 'update_profile', to: 'profiles#update'
      get 'password', to: 'passwords#edit'
      patch 'update_password', to: 'passwords#update'
      get 'user_setting', to: 'user_settings#edit'
      patch 'update_user_setting', to: 'user_settings#update'
      get 'review_schedule/:ym', to: 'review_schedule#schedule', as: 'review_schedule'
      get "oauth/callback", to: "authentications#callback"
      get "oauth/:provider", to: "authentications#oauth", as: :oauth_at_provider
      delete "oauth/:provider", to: "authentications#destroy"
    end
  end

  resources :password_resets, only: %i[new create edit update]

  resources :subjects, only: %i[new create index edit update destroy] do
    resources :subject_details, only: %i[new create index edit update destroy], shallow: true do
      member do
        get 'review_time'
        patch 'update_review_time'
      end
    end
  end

  namespace :admin do
    get 'login', to: 'user_sessions#new'
    post 'login', to: 'user_sessions#create'
    delete 'logout', to: 'user_sessions#destroy'
    resources :dashboards, only: %i[index]
    resources :users, only: %i[index show edit update destroy]
    resources :system_review_settings, only: %i[index] do
      collection do
        put :update_all
      end
    end
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
