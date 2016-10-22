Rails.application.routes.draw do

  namespace :api, defaults:{ format: :json } do
    namespace :v1 do
      # devise_for :users
      resources :users, only: [:show, :create, :destroy, :index]
      resources :groups, only: [:index]
      post '/events' => 'events#create_or_update'
      post '/groups' => 'groups#create_or_update'
      post '/events/find' => 'events#show'
      post '/events/add_movie' => 'events#add_movie'
      post '/events/attending' => 'events#attending'
      post '/events/rating' => 'events#add_rating'
      get '/events/rating/:id/:user_id' => 'events#show_rating'
      post '/events/not_attending' => 'events#not_attending'
      get '/groups/events/:id' => 'groups#events'
      get '/groups/:id/members' => 'groups#members'
      post '/users/user_details' => 'users#user_details'
      post '/groups/join' => 'requests#new'
      resource :login, controller: :sessions
      get 'verify' => 'sessions#verify_access_token'
    end
  end
end
