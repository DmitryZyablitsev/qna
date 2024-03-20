Rails.application.routes.draw do
  root to: "questions#index"
  devise_for :users

  resources :questions do
    resources :answers, shallow: true, only: %i[new create update destroy]
  end

  resources :files, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index

  patch 'answer_best/:id', to: 'answers#best' 

end
