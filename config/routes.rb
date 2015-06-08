Rails.application.routes.draw do
  root to: 'visitors#index'
  devise_for :users, path: ''

  resources :loans
end
