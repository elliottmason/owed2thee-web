class PasswordForm < BaseForm
  attr_writer :user

  define_attributes initialize: true, attributes: true do
    attribute :current_password,          String
    attribute :new_password,              String
    attribute :new_password_confirmation, String
  end

  def current_password?
    current_password
  end
end
