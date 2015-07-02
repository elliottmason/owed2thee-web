module Users
  class SessionsController < Devise::SessionsController
    def new
      @sign_in_form = SignInForm.new(email: session[:user_email])
    end
  end
end
