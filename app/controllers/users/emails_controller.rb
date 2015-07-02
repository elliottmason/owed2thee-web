module Users
  class EmailsController < BaseController
    skip_before_filter :authenticate_user!, only: %i(confirm)

    def confirm
      service = ConfirmUserEmail.with(params[:email],
                                      params[:confirmation_token])

      if service.successful?
        sign_in(service.user)
        redirect_to([:user, :loans])
      else
        redirect_to(:root)
      end
    end
  end
end
