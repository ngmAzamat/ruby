Rails.application.routes.draw do 
  resource :session
  resources :passwords, param: :token
  root "users#index"
  post 'set_theme', to: 'themes#set'
  get '/users/:id', to: 'users#destroy'
  get '/figures/:id', to: 'figures#destroy'
  get '/battles/:id', to: 'battles#destroy'
  get '/countries/:id', to: 'countries#destroy'
  get '/wars/:id', to: 'wars#destroy'
  resources :users, only: [:index, :new, :create, :edit, :update, :destroy]
  resources :figures, only: [:index, :new, :create, :edit, :update]
  resources :battles, only: [:index, :new, :create, :edit, :update]
  resources :countries, only: [:index, :new, :create, :edit, :update]
  resources :wars
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
