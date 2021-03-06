Rails.application.routes.draw do

  namespace :api, defaults:{ format: :json } do
    namespace :v1 do
      # devise_for :users
      resources :users, only: [:show, :create, :destroy, :index]
      resources :groups, only: [:index]
      resource :login, controller: :sessions
      get 'verify' => 'sessions#verify_access_token'

      post '/users/user_details' => 'users#user_details'

      post '/events' => 'events#create_or_update'
      post '/events/find' => 'events#show'
      post '/events/add_movie' => 'events#add_movie'
      post '/events/rating' => 'events#add_rating'
      post '/events/attending' => 'events#attending'
      post '/events/show_rating' => 'events#show_rating'
      post '/events/destroy' => 'events#destroy'
      post '/events/not_attending' => 'events#not_attending'

      post '/groups' => 'groups#create_or_update'
      post '/groups/events' => 'groups#events'
      post '/groups/add_user' => 'groups#add_user'
      post '/groups/members' => 'groups#members'

      post '/groups/join' => 'requests#new'
      get 'requests/deny/:id' => 'requests#deny_request'
    end
  end
end
