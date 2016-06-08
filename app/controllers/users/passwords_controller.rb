module Users
  class PasswordsController < BaseController
    skip_before_action :authenticate_user!, only: %i(edit update)

    def edit
      unless user_signed_in? || valid_confirmation_token?
        return head 403
      end

      @password_form = PasswordForm.new(confirmation_token: confirmation_token)
    end

    def update
      service = ChangeUserPassword.with(current_user, params[:password])

      flash_message_for_update(service.successful?)

      if service.successful?
        sign_in(service.user, bypass: true)
        redirect_to %i(edit user password)
      else
        @password_form = service.form
        render :edit
      end
    end

    private

    def confirmation_token
      params[:confirmation_token]
    end

    def flash_message_for_update(successful = false)
      if successful
        flash[:success] = t('passwords.notices.update_success')
      else
        flash[:error] = t('passwords.notices.update_failure')
      end
    end

    def valid_confirmation_token?
      confirmation_token.present? &&
        PasswordResetQuery.active_confirmation_token?(confirmation_token)
    end
  end
end
