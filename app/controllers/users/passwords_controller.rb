module Users
  class PasswordsController < BaseController
    def edit
      @password_form = PasswordForm.new
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

    def flash_message_for_update(successful = false)
      if successful
        flash[:success] = t('passwords.notices.update_success')
      else
        flash[:error] = t('passwords.notices.update_failure')
      end
    end
  end
end
