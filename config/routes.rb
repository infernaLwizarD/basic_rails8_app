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
    authenticated :user do
      root to: 'home#index', as: :authenticated_root

      # Hotwire demo routes
      post 'change_frame1_color', to: 'home#change_frame1_color'
      post 'change_frame2_color', to: 'home#change_frame2_color'
      post 'reset_colors', to: 'home#reset_colors'

      resources :users do
        member do
          post :lock
          post :unlock
          post :restore
        end
      end
    end

    #--- DEVISE AUTHENTICATION ---#
    devise_for :users, path: 'auth', controllers: {
      sessions: 'web/users/sessions',
      registrations: 'web/users/registrations',
      passwords: 'web/users/passwords',
      confirmations: 'web/users/confirmations',
      unlocks: 'web/users/unlocks'
    }

    devise_scope :user do
      unauthenticated do
        root to: 'users/sessions#new'
      end
    end
    #----#
  end
end
