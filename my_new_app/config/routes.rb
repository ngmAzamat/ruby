Rails.application.routes.draw do
  root "pages#home"               # http://127.0.0.1:3000/
  get "/about", to: "pages#about" # http://127.0.0.1:3000/about
end
