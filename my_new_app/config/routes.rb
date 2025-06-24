Rails.application.routes.draw do
  get "search/search"
  get "notes/index"
  # Healthcheck
  get "up" => "rails/health#show", as: :rails_health_check
  get '/search', to: 'search#search', as: 'search'

  # Правильный RESTful ресурс
  resources :users do
    member do
      get :delete  # для страницы подтверждения удаления
    end
  end

  resources :notes do
    member do
      get :delete  # для страницы подтверждения удаления
    end
  end


  # Корень сайта
  root "users#index"
end