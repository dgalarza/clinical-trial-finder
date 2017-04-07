Rails.application.routes.draw do
  root to: "trials#index"

  namespace :admin do
    root to: "dashboards#show"
    resources :import_logs, only: [:index]
    resource :dashboard, only: [:show]
    resource :configuration, only: [:edit, :update]
  end
  resources :trials, only: [:index, :show]
  resource :filters, only: [:destroy]
  get "/robots.txt" => "robots_txts#show"
end
