Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  get "signup" => "registrations#new", as: :signup
  post "signup" => "registrations#create"
  get "login" => "sessions#new", as: :login
  post "login" => "sessions#create"
  delete "logout" => "sessions#destroy", as: :logout

  get "profile/edit" => "users#edit", as: :edit_profile
  patch "profile" => "users#update", as: :profile

  resources :foods, only: %i[index new create]
  resources :food_logs, only: %i[index new create destroy]

  resources :exercises, only: %i[index show]

  resources :workout_templates do
    resources :workout_template_exercises, only: %i[create update destroy], shallow: true
  end

  resources :workout_logs, only: %i[index new create show update] do
    resources :set_logs, only: %i[create update], shallow: true
  end

  # Defines the root path route ("/")
  root "dashboard#show"
end
