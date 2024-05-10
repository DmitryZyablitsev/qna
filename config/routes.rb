Rails.application.routes.draw do
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

  patch 'answer_best/:id', to: 'answers#best' 

end
