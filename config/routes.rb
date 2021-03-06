Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/', to:'welcome#index', as: 'root'

  get 'auth/google_oauth2', as: 'google_oauth2_login'
  get '/auth/google_oauth2/callback', to: 'sessions#create'

  get '/logout', to: 'sessions#destroy'

  get '/about', to: 'about#show'
  get '/profile', to: 'users#show'

  get '/search', to: 'search#new'
  post '/search', to: 'search#create'

  namespace :climbs do
    get '/trips/new', to: "trips#new"
    post '/trips/create', to: "trips#create"
  end

  namespace :search do
    get '/climbs/new', to: 'climbs#new'
    get '/hikes/new', to: 'hikes#new'
  end

  resources :trips, only: [:show]

  namespace :hikes do
    get '/trips/new', to: 'trips#new'
    post '/trips/create', to: 'trips#create'
  end

  namespace :trips do
    get '/:trip_id/search/hikes', to: 'hikes#new'
    get '/:trip_id/search/hikes/index', to: 'hikes#index'
    post '/:trip_id/hikes/create', to: 'hikes#create'
    get '/:trip_id/search/climbs', to: 'climbs#new'
    get '/:trip_id/search/climbs/index', to: 'climbs#index'
    post '/:trip_id/climbs/create', to: 'climbs#create'
  end

end
