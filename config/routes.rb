Rails.application.routes.draw do
  devise_for :users
  root to: "application#index"

  resources :receipts, except: :new do
    resources :transactions, shallow: true, except: [:edit, :new, :show]
  end

  namespace :data do
    get '/', controller: "/data", action: :index
  end

  namespace :api do
    get 'store/(:query)', controller: "/stores", action: :search, as: :store_search
    get 'item/(:query)', controller: "/items", action: :search, as: :item_search
  end
end
