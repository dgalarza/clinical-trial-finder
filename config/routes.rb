Rails.application.routes.draw do
  root to: "trials#index"

  namespace :admin do
    resources :import_logs, only: [:index]
  end
  resources :trials, only: [:index, :show]
  resource :filters, only: [:destroy]
end
