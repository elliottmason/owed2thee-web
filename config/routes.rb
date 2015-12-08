Rails.application.routes.draw do
  root to: 'visitors#index'

  devise_for :users, only: []

  resources :loans, module: 'users', only: %i(index)

  resources :loans, only: %i(create new show), param: :uuid do
    resources :comments,  only: %i(create), module: 'loans'

    member do
      %w(cancel confirm dispute).each do |verb|
        patch(verb)
        put(verb)
      end
    end
  end

  resources :payments, only: %i(create new show), param: :uuid do
    member do
      patch 'confirm'
      put 'confirm'
    end
  end

  resources :users, param: :uuid do
    resources :payments, only: %i(create new)
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
          post 'create',  path: 'sign_in'
          get 'create',   path: 'sign_in/:confirmation_token'
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
              param:        :email_address do
      member do
        get 'confirm', path: 'confirm/:confirmation_token'
      end
    end

    resource :password, only: %i(edit update), path: 'account/password'
  end # namespace :users
end
