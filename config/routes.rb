Rails.application.routes.draw do
  devise_for(:users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" })
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  devise_scope(:user) do
    authenticated(:user) do
      root(to: "posts#index", as: :authenticated_homepage)
    end

    unauthenticated(:user) do
      root(to: "devise/sessions#new")
    end
  end

  resources(:posts)

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get("up" => "rails/health#show", :as => :rails_health_check)
  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
