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
    get '/', controller: "/community", action: :index
    get '/submit-new-store', action: :new_store_submission, as: :new_store
    post '/submit-new-store', action: :create_store_submission, as: :create_store
    get '/submit-new-item', action: :new_item_submission, as: :new_item
    post '/submit-new-item', action: :create_item_submission, as: :create_item
  end

  namespace :admin do
    get '/', controller: "/admin", action: :index

    resources :items, only: [:index, :create, :destroy]
    get 'items/submissions'
    resources :stores, only: [:index, :create, :destroy]
    get 'stores/submissions'

    resources :submissions, only: [:destroy] do
      post :validate
    end
  end

  namespace :api do
    resource :session, only: [:create, :destroy]
    resource :registration, only: [:create]
    resources :receipts, only: [:index, :create]
    delete 'transactions', controller: "transactions", action: :delete_transactions
    get 'store/(:query)', controller: "/stores", action: :search, as: :store_search
    get 'item/(:query)', controller: "/items", action: :search, as: :item_search
  end
end
