class PasswordForm < ApplicationForm
  I18N_ERRORS_SCOPE = 'activerecord.errors.models.password_form'.freeze

  # include ActiveModel::Validations

  attribute :confirmation_token,        String
  attribute :current_password,          String
  attribute :new_password,              String
  attribute :new_password_confirmation, String

  validate :current_password_must_be_valid, if: :require_current_password?
  validates :new_password,  confirmation: true,
                            length: { minimum: 6 },
                            presence: true

  def initialize(params, user = nil)
    @user = user
    super(params)
  end

  def password_reset
    return @password_reset if @password_reset

    @password_reset = PasswordResetQuery.
                      first_with_active_confirmation_token(confirmation_token)
  end

  def user
    return @user if @user
    @user = password_reset.user if password_reset
  end

  private

  def confirmation_token_valid?
    password_reset.present?
  end

  def current_password_must_be_valid
    errors.add(
      :current_password,
      I18n.t('attributes.current_password.invalid', scope: I18N_ERRORS_SCOPE)
    ) unless current_password_valid?
  end

  def current_password_valid?
    user.valid_password?(current_password)
  end

  def require_current_password?
    true unless confirmation_token_valid? || user_has_no_password?
  end

  def user_has_no_password?
    user && user.encrypted_password.blank?
  end
end
