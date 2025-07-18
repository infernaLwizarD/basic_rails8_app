Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  scope module: :web do
    #--- users ---#
    authenticated :user do
      root to: 'home#index', as: :authenticated_root
    end
    root to: redirect('/users/sign_in')

    devise_for :users, controllers: {
      sessions: 'web/users/sessions',
      registrations: 'web/users/registrations',
      passwords: 'web/users/passwords',
      confirmations: 'web/users/confirmations',
      unlocks: 'web/users/unlocks'
    }

    scope '/admin' do
      resources :users, except: %i[show edit update destroy]
    end

    resources :users, only: %i[show edit update destroy] do
      member do
        post :lock
        post :unlock
        post :restore
      end
    end
    #----#
  end
end
