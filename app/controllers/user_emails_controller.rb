class UserEmailsController < ApplicationController
  def confirm
    service = ConfirmUserEmail.with(
      confirmation_token: params[:confirmation_token],
      email:              params[:email]
    )

    if service.successful?
      sign_in(service.user)
      redirect_to(:loans)
    else
      redirect_to(:root)
    end
  end
end
