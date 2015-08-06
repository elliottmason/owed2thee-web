require 'support/pages/form_section'

class SignInPage < SitePrism::Page
  include FormSection

  set_url '/sign_in'
  set_url_matcher %r{sign_in$}

  form_section :sign_in,
               fields:        %i(email password),
               field_prefix:  'user',
               selector:      '#new_user'

  element :email_field,     '#user_email'
  element :password_field,  '#user_password'
end
