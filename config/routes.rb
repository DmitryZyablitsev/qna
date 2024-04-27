Rails.application.routes.draw do
  root to: "questions#index"
  devise_for :users

  resources :questions do
    resources :answers, shallow: true, only: %i[new create update destroy]
  end

  resources :files, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index
  resources :likes, only: %i[create destroy]

  patch 'answer_best/:id', to: 'answers#best'

  mount ActionCable.server => '/cable'
end
