class PasswordForm < ApplicationForm
  I18N_ERRORS_SCOPE = 'activerecord.errors.models.password_form'

  include ActiveModel::Validations

  attr_writer :current_password_valid
  attr_writer :require_current_password
  attr_writer :user

  attribute :current_password,          String
  attribute :new_password,              String
  attribute :new_password_confirmation, String

  validate :current_password_must_be_valid, if: :require_current_password?
  validates :new_password, confirmation: true, presence: true

  private

  def current_password_must_be_valid
    errors.add(
      :current_password,
      I18n.t('attributes.current_password.invalid', scope: I18N_ERRORS_SCOPE)
    ) unless current_password_valid?
  end

  attr_reader :current_password_valid
  alias current_password_valid? current_password_valid

  attr_reader :require_current_password
  alias require_current_password? require_current_password
end
