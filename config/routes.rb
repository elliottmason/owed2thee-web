Rails.application.routes.draw do
  root to: 'visitors#index'

  devise_for :users,
             controllers:  { sessions:  'users/sessions'},
             only:          %i(sessions),
             path:          '',
             sign_out_via:  %i(get)

  # devise_for :users,
  #            controllers: { passwords: 'users/password_resets' },
  #            only:        %i(passwords),
  #            path:        'account',
  #            path_names:  { password: 'password_resets' }

  resources :loans, module: 'users', only: %i(index)

  resources :loans, only: %i(create new show), param: :uuid do
    resources :comments,  only: %i(create), module: 'loans'
    resources :payments,  only: %i(create new), param: :uuid

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

  namespace :users, as: 'user', path: 'account' do
    devise_scope :users do
      resources :password_resets, path: 'password/reset'
    end

    resources :email_addresses,
              constraints:  { email_address: /.+(?:@|%40).+\..+/ },
              path:         'emails',
              only:         %i(edit update),
              param:        :email_address do
      member do
        get 'confirm', path: 'confirm/:confirmation_token'
      end
    end
    resource :password, only: %i(edit update)
  end
end
