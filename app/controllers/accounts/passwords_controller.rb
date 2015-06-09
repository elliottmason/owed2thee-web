module Users
  class PasswordsController < BaseController
    before_filter :authenticate_user!

    def edit
      @password = PasswordForm.new(user: current_user)
    end

    def update
      service = ChangeUserPassword.with(current_user, params[:password])

      if service.successful?
        sign_in(current_user)
        redirect_to([:users, :profile])
      else
        @password = service.form
        render :edit
      end
    end
  end
end
