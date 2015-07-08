module Users
  class PasswordsController < BaseController
    def edit
      @password_form = PasswordForm.new
    end

    def update
    end
  end
end
