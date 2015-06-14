class SignInPage < SitePrism::Page
  include FormSection

  set_url '/sign_in'
  set_url_matcher %r{sign_in}

  element :email_field,     '#user_email'
  element :password_field,  '#user_password'
end
