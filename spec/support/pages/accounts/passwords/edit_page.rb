require 'support/pages/form_section'

module Accounts
  module Passwords
    class EditPage < SitePrism::Page
      include ::FormSection

      set_url '/account/password/edit'

      form_section(
        :password,
        fields:   %i(current_password new_password new_password_confirmation),
        selector: '#new_password'
      )
    end
  end
end
