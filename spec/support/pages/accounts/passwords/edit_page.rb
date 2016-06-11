require 'support/pages/form_section'

module Accounts
  module Passwords
    class EditPage < SitePrism::Page
      include ::FormSection

      set_url '/account/password/change{/confirmation_token}'
      set_url_matcher %r{/account/password/change(/[A-Za-z0-9\-_]{1,})?}

      form_section(
        :password,
        fields:   %i(current_password new_password new_password_confirmation),
        selector: '#new_password'
      )

      def reset_password_to(new_password)
        password_form.new_password_field.set(new_password)
        password_form.new_password_confirmation_field.set(new_password)
        password_form.submit
      end
    end
  end
end
