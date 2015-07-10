class PasswordForm < BaseForm
  include ActiveModel::Validations

  attr_writer :user

  define_attributes initialize: true, attributes: true do
    attribute :current_password,          String
    attribute :new_password,              String
    attribute :new_password_confirmation, String
  end

  validates :new_password, confirmation: true

  def new_record?
    false
  end
end
