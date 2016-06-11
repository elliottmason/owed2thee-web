module Users
  class SessionsController < Devise::SessionsController
    skip_before_action :authenticate_user!, only: %i(new)
    skip_after_action :verify_authorized
    skip_after_action :verify_policy_scoped

    helper_method :can_sign_in?

    def new
      retrieve_tentative_user

      if can_sign_in?
        @sign_in_form = SignInForm.new(email: saved_email_address)
      else
        flash.clear
        CreatePasswordReset.for(saved_email_address)
      end
    end

    def create
      super do |user|
        if user
          redirect_to after_sign_in_path_for(user)
          return
        end
      end
    end

    private

    attr_reader :tentative_user

    def after_sign_in_path_for(user)
      return [:edit, :user, :password] if user.no_password?
      super
    end

    def can_sign_in?
      !tentative_user ||
        (tentative_user.confirmed? && tentative_user.encrypted_password?)
    end

    def retrieve_tentative_user
      return unless saved_email_address

      @tentative_user = UserQuery.email_address(saved_email_address)
    end

    def saved_email_address
      session[:email_address]
    end
  end
end
