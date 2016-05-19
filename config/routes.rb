Rails.application.routes.draw do
  root to: 'visitors#index'

  devise_for :users, only: []

  resources :email_address_confirmations,
            path:   'email_address/confirm',
            only:   %i(),
            param:  :confirmation_token do
    scope module: 'email_address_confirmations' do
      resource :redemption,
               only: %i(),
               path: '' do
        member do
          get :create
        end
      end
    end
  end

  resources :loan_requests, param: :uuid, only: %i(create new show)

  resources :loans, module: 'users', only: [] do
    collection do
      get '(:page)', action: :index, as: '', constraints: { page: /[1-9]\d*/ }
    end
  end

  resources :loans,
            constraints:  { uuid: /[a-f0-9\-]{36}/i },
            only:         %i(create new show),
            param:        :uuid do
    member do
      %w(cancel confirm dispute publish).each do |action|
        patch(action)
        put(action)
      end
    end

    scope module: 'loans' do
      resources :descriptions #,  only: %i(create)
      resources :payments,      only: %i(create new)
    end
  end

  resources :payments, only: %i(show), param: :uuid do
    member do
      %w(confirm publish).each do |action|
        patch(action)
        put(action)
      end
    end
  end

  namespace :users, as: 'user', path: '' do
    devise_scope :user do
      resource :password_reset, only: %i(new),
                                path: 'account/password',
                                path_names: {
                                  new:    'forgot'
                                } do
        collection do
          post 'create', path: 'forgot'
        end
      end # resource :password_reset

      resource :session, only: %i(new),
                         path: '',
                         path_names: {
                           new: 'sign_in'
                         } do
        collection do
          match 'create', path: 'sign_in(/:confirmation_token)',
                          via: %i(get post)
        end

        member do
          delete 'destroy', path: 'sign_out'
          get 'destroy',    path: 'sign_out'
        end
      end # resource :session
    end # devise_scope :user

    resources :email_addresses,
              constraints:  { email_address: /.+(?:@|%40).+\..+/ },
              path:         'account/emails',
              only:         %i(edit update),
              param:        :email_address

    resource :password, only: %i(edit update), path: 'account/password'
  end # namespace :users
end
