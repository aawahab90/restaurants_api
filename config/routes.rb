Rails.application.routes.draw do
  
  post 'auth/login', to: 'authentication#authenticate'
  namespace :api, defaults: { format: 'json' } do
    scope '/v1', module: :v1 do
      resources :users, only: [:create] do
      	member do
      		post :update_role
      	end
      end
      resources :restaurants, except: [:edit, :new] do
        resources :guests, except: [:edit, :new]
        resources :reservations, except: [:edit, :new, :index] do
          member do
            put :update_status
          end
        end
      end
    end
  end
  get '/api/v1/reservations', to: 'api/v1/reservations#index'
end
