module Users
  class PasswordsController < BaseController
    def edit
      @password_form = PasswordForm.new
    end

    def update
      service = ChangeUserPassword.with(current_user, params[:password])

      if service.successful?
        sign_in(service.user, bypass: true)
        flash[:success] = 'Success'
        redirect_to %i(edit user password)
      else
        flash[:error] = 'Failed'
        @password_form = service.form
        render :edit
      end
    end
  end
end
