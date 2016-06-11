module EmailAddressConfirmations
  class RedemptionsController < BaseController
    skip_before_action :authenticate_user!, only: %i(create)
    skip_after_action :verify_authorized
    skip_after_action :verify_policy_scoped

    def create
      service = RedeemEmailAddressConfirmation.with(confirmation_token)

      if service.successful?
        flash[:success] = t('email_addresses.notices.confirmation',
                            email_address: service.email_address.address)
        sign_in(service.user)
      end
      redirect_to(redirect_for_create(service))
    end

    private

    def confirmation_token
      params[:email_address_confirmation_confirmation_token]
    end

    def redirect_for_create(service)
      (service.successful? &&
       LoanQuery.most_recent_incomplete_for_user(service.user)) || :loans
    end
  end
end
