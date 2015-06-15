require 'support/pages/form_section'

module Accounts
  module Passwords
    class EditPage < SitePrism::Page
      include ::FormSection

      set_url '/account/password/edit'

      element :new_password_field, '#password_new_password'
      element :new_password_confirmation_field,
              '#password_new_password_confirmation'
    end
  end
end
