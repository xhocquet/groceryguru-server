Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  root to: "application#index"

  resources :receipts, except: [:new, :edit] do
    resources :transactions, shallow: true, only: [:create, :update, :destroy]
  end

  namespace :stats do
    get '/', controller: "/stats", action: :index
  end

  namespace :community do
    get '/submit-new-store', controller: "/stores", action: :new_submission, as: :new_store
    post '/submit-new-store', controller: "/stores", action: :create_submission, as: :create_store
  end

  namespace :admin do
    get '/', controller: "/admin", action: :index
    resources :items, controller: "/items", only: [:index, :destroy]
    resources :stores, controller: "/stores", only: [:index, :destroy]
  end

  namespace :api do
    get 'store/(:query)', controller: "/stores", action: :search, as: :store_search
    get 'item/(:query)', controller: "/items", action: :search, as: :item_search
  end
end
