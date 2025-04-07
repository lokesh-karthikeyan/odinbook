Rails.application.routes.draw do
  devise_for(:users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" })
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  devise_scope(:user) do
    authenticated(:user) do
      root(to: "posts#feed", as: :authenticated_homepage)
    end

    unauthenticated(:user) do
      root(to: "devise/sessions#new")
    end

    match("login", to: "devise/sessions#new", via: [ :get, :post ])
    match("sign_up", to: "devise/registrations#new", via: [ :get, :post ])
  end

  resources(:users, only: [ :index, :show ]) do
    resource(:profile, only: [ :show, :edit, :update ]) do
      resources(:posts, only: [ :create ])
    end

    member do
      get(:following, to: "users#following")
      get(:followers, to: "users#followers")
      get(:posts, to: "users#posts")
    end
  end

  resources(:posts, only: [ :new, :create, :destroy ]) do
    member do
      post(:like, to: "likes#create")
      delete(:unlike, to: "likes#destroy")
    end

    resources(:comments, only: [ :new, :create ])
  end

  resources(:relationships, only: [ :create, :update, :show, :destroy ])

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get("up" => "rails/health#show", :as => :rails_health_check)
  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
