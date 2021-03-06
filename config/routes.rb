Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :movies, only: :index
      resources :seasons, only: :index
      resources :purchase_options, only: [] do
        resources :purchases, only: :create
      end
      resources :users, only: [] do
        member do
          get 'library', to: 'users#library'
        end
      end

      get 'movies_and_seasons', to: 'movies_and_seasons#index'
    end
  end
end
