require 'support/pages/form_section'

module Accounts
  module Passwords
    class ForgotPage < SitePrism::Page
      include ::FormSection

      set_url '/account/password/forgot'

      form_section(
        :email,
        field_prefix: :user,
        fields:       %i(email_address),
        selector: '   #reset_password'
      )
    end
  end
end
