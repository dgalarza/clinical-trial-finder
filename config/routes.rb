Rails.application.routes.draw do
  root to: "trials#index"

  resources :trials, only: [:index, :show]
end
