module Users
  class EmailAddressesController < BaseController
    skip_before_filter :authenticate_user!, only: %i(confirm)

    def confirm
      service = ConfirmEmailAddress.with(params[:email_address],
                                         params[:confirmation_token])

      sign_in(service.user) if service.successful?
      confirmation_flash_message(service.email_address)
      redirect_to(confirmation_redirect_path(service.user))
    end

    private

    def confirmation_redirect_path(user)
      if user.present? && (user.new? || user.password?)
        :loans
      elsif user.present? && user.no_password?
        %i(edit user password)
      else
        :root
      end
    end

    def confirmation_flash_message(email_address)
      return unless email_address && email_address.confirmed?

      confirmable = t('controllers.application.confirm.email_address',
                      email_address: email_address.address)
      flash[:success] =
        t('controllers.application.confirm.flash.notice',
          confirmable: confirmable)
    end
  end
end
