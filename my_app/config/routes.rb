Rails.application.routes.draw do 
  resource :session
  resources :passwords, param: :token
  root "users#index"
  post 'set_theme', to: 'themes#set'
  get '/users/:id/confirm_destroy', to: 'users#confirm_destroy'
  get '/figures/:id/confirm_destroy', to: 'figures#confirm_destroy'
  get '/battles/:id/confirm_destroy', to: 'battles#confirm_destroy'
  get '/countries/:id/confirm_destroy', to: 'countries#confirm_destroy'
  get '/wars/:id/confirm_destroy', to: 'wars#confirm_destroy'
  get '/events/:id/confirm_destroy', to: 'events#confirm_destroy'
  resources :users, only: [:index, :create, :edit, :update, :destroy]
  resources :figures, only: [:index, :new, :create, :edit, :update, :destroy]
  resources :battles, only: [:index, :new, :create, :edit, :update, :destroy]
  resources :countries, only: [:index, :new, :create, :edit, :update, :destroy]
  resources :wars, only: [:index, :new, :create, :edit, :update, :destroy]
  resources :events, only: [:index, :new, :create, :edit, :update, :destroy]
  resources :profiles, only: [:index, :edit, :update]
  delete "/logout", to: "sessions#destroy"
  get "/logout_via_get", to: "sessions#destroy" # <- временный костыль
  get "/about", to: "pages#about" 
  get "/abouts", to: "pages#abouts" 
  get "/data", to: "pages#data"
  post "/data", to: "pages#data"
  get "/courses", to: "pages#courses"
  get "sign_up", to: "registrations#new"
  post "sign_up", to: "registrations#create"
  get "sign_in", to: "sessions#new"
  post "sign_in", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
end
