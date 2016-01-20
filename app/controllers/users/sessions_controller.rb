module Users
  class SessionsController < Devise::SessionsController
    skip_after_action :verify_authorized
    skip_after_action :verify_policy_scoped

    helper_method :can_sign_in?

    def new
      retrieve_tentative_user

      begin
        authorize(tentative_user, :sign_in?) if tentative_user
        @sign_in_form = SignInForm.new(email: session[:email_address])
      rescue Pundit::NotAuthorizedError
        flash.clear
        CreateTemporarySignin.for(tentative_user)
      end
    end

    def create
      super do |user|
        if user
          redirect_to after_sign_in_path_for(resource)
          return
        end
      end
    end

    private

    def after_sign_in_path_for(user)
      return [:edit, :user, :password] if user.no_password?
      super
    end

    def can_sign_in?
      !tentative_user || policy(tentative_user).sign_in?
    end

    def retrieve_tentative_user
      return unless session[:email_address]

      @tentative_user = UserQuery.email_address(session[:email_address])
    end

    attr_reader :tentative_user
  end
end
