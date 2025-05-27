Rails.application.routes.draw do 
  root "users#new"
  resources :users, only: [:index, :new, :create, :edit, :update]
  resources :figures, only: [:index, :new, :create, :edit, :update]
  resources :battles, only: [:index, :new, :create, :edit, :update]
  resources :countries, only: [:index, :new, :create, :edit, :update]
  resources :wars
  get "/about", to: "pages#about" 
  get "/abouts", to: "pages#abouts" 
  get "/data", to: "pages#data"
  post "/data", to: "pages#data"
  get "/courses", to: "pages#courses"
  
end
