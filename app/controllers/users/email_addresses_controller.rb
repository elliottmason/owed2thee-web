module Users
  class EmailAddressesController < BaseController
    skip_before_filter :authenticate_user!, only: %i(confirm)

    def confirm
      service = ConfirmEmailAddress.with(params[:email_address],
                                         params[:confirmation_token])

      sign_in(service.user) if service.successful?
      redirect_to(confirmation_redirect_path(service.user))
    end

    private

    def confirmation_redirect_path(user)
      if user && user.password_blank?
        %i(edit user password)
      elsif user && user.confirmed?
        :loans
      else
        :root
      end
    end
  end
end
