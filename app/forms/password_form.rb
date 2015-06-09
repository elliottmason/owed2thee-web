class PasswordForm < BaseForm
  attr_writer :user

  define_attributes initialize: true, attributes: true do
    attribute :current_password,          String
    attribute :new_password,              String
    attribute :new_password_confirmation, String
  end

  def current_password?
    @user.encrypted_password.present? ? true : false
  end

  def new_record?
    !current_password?
  end

  alias_method :persisted?, :current_password?
end
