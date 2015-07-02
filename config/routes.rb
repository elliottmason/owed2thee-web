Rails.application.routes.draw do
  root to: 'visitors#index'

  devise_for :users,
             controllers:  { sessions:  'users/sessions'},
             only:          %i(sessions),
             path:          '',
             sign_out_via:  %i(get)
  devise_for :users,
             controllers: { passwords: 'users/passwords' },
             only:        %i(passwords),
             path:        'account'

  resources :loans, module: 'users', only: %i(index)

  resources :loans, only: %i(create new show), param: :uuid do
    resources :payments, only: %i(create new), param: :uuid

    member do
      patch 'cancel'
      put 'cancel'
      patch 'confirm'
      put 'confirm'
      patch 'dispute'
      put 'dispute'
    end
  end

  resources :payments, only: %i(show), param: :uuid do
    member do
      patch 'confirm'
      put 'confirm'
    end
  end

  namespace :users, as: :account, path: 'account' do
    resources :emails,
              as:           :user_emails,
              constraints:  { email: /.+(?:@|%40).+\..+/ },
              only:         %i(edit update),
              param:        :email do
      member do
        get 'confirm', path: 'confirm/:confirmation_token'
      end
    end
  end
end
