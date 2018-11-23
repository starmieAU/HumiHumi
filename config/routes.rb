Rails.application.routes.draw do
  resources :toppages, only: [:index] do
    collection do
      get :index_users
    end
  end
  root 'toppages#index'
  get '/humihumi', to: 'toppages#what'
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/signout', to: 'sessions#destroy'
  resources :books, only: [:show, :new] do
    member do
      get :favorite_users
      get :shelf_users
    end
  end
  resources :reviews, only: [:show, :edit, :destroy, :create, :index, :update] do
    collection do
      get :rank_shelf
      get :rank_favorite
      get :rank_short
      get :rank_long
    end
  end
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
