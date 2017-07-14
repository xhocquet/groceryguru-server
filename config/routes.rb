Rails.application.routes.draw do
  devise_for :users
  root to: "application#index"
  resources :receipts, except: :new
end
