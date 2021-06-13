Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :movies, only: :index
      resources :seasons, only: :index
      get 'movies_and_seasons', to: 'movies_and_seasons#index'
    end
  end
end
