# ruby

создать ruby on rails приложение? не проблема!

инструкция:

ruby -v
rails -v
node -v
yarn -v
rails new my_app
cd my_app
bundle install
yarn install
rails generate controller Pages home about
config/routes.rb:
`Rails.application.routes.draw do root "pages#home" get "/about", to: "pages#about" end`
bin/rails server
