Rails.application.routes.draw do
  # Healthcheck
  get "up" => "rails/health#show", as: :rails_health_check
  get '/search', to: 'search#search', as: 'search'

  # Сессии (логин/логаут)
  resource :session, only: [:new, :create, :destroy]
  # Ресурсы
  resources :users do
    member do
      get :delete
    end
  end

  resources :notes do
    member do
      get :delete
    end
  end

  root "users#index"
end
