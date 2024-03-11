Rails.application.routes.draw do
  root to: "questions#index"
  devise_for :users

  resources :questions do
    resources :answers, shallow: true, only: %i[new create update destroy]
  end

  patch 'answer_best/:id', to: 'answers#best' 

end
