Rails.application.routes.draw do
  root to: "trials#index"

  resources :import_logs, only: [:index]
  resources :trials, only: [:index, :show]
end
