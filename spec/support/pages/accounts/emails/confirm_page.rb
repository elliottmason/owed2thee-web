module Accounts
  module Emails
    class ConfirmPage < SitePrism::Page
      set_url '/account/emails{/email}/confirm{/confirmation_token}'
    end
  end
end
