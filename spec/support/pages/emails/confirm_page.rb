module Emails
  class ConfirmPage < SitePrism::Page
    set_url '/email_address/confirm{/confirmation_token}'
  end
end
