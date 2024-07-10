require 'sidekiq/web'

Rails.application.routes.draw do

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  root to: "questions#index"
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  resources :questions do
    resources :answers, shallow: true, only: %i[new create update destroy]
  end

  resources :comments, only: %i[create]
  resources :files, only: :destroy
  resources :rewards, only: :index
  resources :likes, only: %i[create destroy]
  resources :links, only: :destroy
  resources :subscriptions, only: %i[create destroy]

  patch 'answer_best/:id', to: 'answers#best' 
  get '/search', to: 'search#search'

  namespace :api do
    namespace :v1 do
      resources :profiles, only: :index do
        get :me, on: :collection
      end

      resources :questions, except: %i[new edit] do
        get :answers, on: :member
        resources :answers, shallow: true, only: %i[show create update destroy]
      end
    end
  end
end
