Rails.application.routes.draw do
  root to: 'visitors#index'

  devise_for :users,  controllers: { sessions: 'users/sessions' },
                      path: ''

  resources :loan_participants do
    member do
      post 'confirm'
    end
  end
  resources :loans, only: [:create, :show]
  resources :user_emails, param: :email do
    member do
      get 'confirm'
    end
  end

  namespace :users, as: :user, only: [], path: 'user' do
    resources :loans,     only: [:index]
    resource  :password,  only: [:edit, :update]
    resource  :profile,   only: [:edit, :update]
  end
end
