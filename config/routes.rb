Rails.application.routes.draw do
  root to: "homepage#show"

  resources :articles, only: [:index]
  resources :frequently_asked_questions, only: [:index]
  resources :trials, only: [:index]
end
