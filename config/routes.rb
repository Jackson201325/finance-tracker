Rails.application.routes.draw do
  devise_for :users, :controllers => { :registrations => "user/registrations"}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "pages#home"
  get "my_portfolio", to: "users#my_portfolio"

  get "search_stocks", to: "stocks#search"

  resources :user_stocks, only: [:create, :destroy]
  resources :users, only:[:show]
  resources :friendships
  get "search_friends", to: "users#search"

  get "my_friends", to: "users#my_friends"

  # a route to add_my_friend to users controller action add_friend
  post "add_friend", to: "users#add_friend"
end
