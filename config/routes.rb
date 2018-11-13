Rails.application.routes.draw do
  root 'toppages#index'
  get '/humihumi', to: 'toppages#what'
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/signout', to: 'sessions#destroy'
  resources :books, only: [:show, :new]
  resources :reviews, only: [:show, :edit, :destroy, :create, :index, :update]
  resources :users, only: [:index, :show, :edit, :update] do
    member do
      get :followings
      get :followers
      get :shelves
      post :tweet
    end
  end
  resources :user_relations, only: [:create, :destroy]
  get "/auth/failure" ,to: "sessions#failure"
end
