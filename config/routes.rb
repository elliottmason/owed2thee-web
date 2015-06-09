Rails.application.routes.draw do
  root to: 'visitors#index'

  devise_for :users,  controllers: { sessions: 'users/sessions' },
                      path: ''

  resources :loans, only: [:create, :new, :show]

  namespace :accounts, as: :account, only: [], path: 'account' do
    resources :emails,
              as:           :user_emails,
              constraints:  { email: /.+@.+\..+/ },
              only:         [],
              param:        :email,
              path_names:   { edit: 'change' } do
      member do
        get 'confirm', path: 'confirm/:confirmation_token'
      end
    end

    resources :loans,     only: [:index] do
      collection do
        get 'borrowed'
        get 'lent'
      end

      member do
        patch 'cancel'
        put   'cancel'
        patch 'confirm'
        put   'confirm'
        patch 'dispute'
        put   'dispute'
      end
    end
    resource  :password,  only: [:edit, :update]
    resource  :profile,   only: [:edit, :update]
  end
end
