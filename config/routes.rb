Rails.application.routes.draw do
  root 'toppages#index'
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/signout', to: 'sessions#destroy'
  resources :books, only: [:show, :new]
  resources :reviews, only: [:show, :edit, :destroy, :create, :index]

end
