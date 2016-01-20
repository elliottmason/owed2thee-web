module Users
  class PasswordResetsController < Devise::PasswordsController
    skip_after_action :verify_authorized
    skip_after_action :verify_policy_scoped

    def create
      service = FindOrCreatePasswordReset.with(params[:user][:email_address])

      return if service.successful?

      @password_reset_form = PasswordResetForm.new
      render :new
    end

    def new
      @password_reset_form = PasswordResetForm.new
    end

    # protected

    # def after_resetting_password_path_for(resource)
    #   super(resource)
    # end

    # The path used after sending reset password instructions
    # def after_sending_reset_password_instructions_path_for(resource_name)
    #   super(resource_name)
    # end
  end
end
