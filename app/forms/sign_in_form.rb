class SignInForm < BaseForm
  include Lean::Attributes

  attribute :email,     String
  attribute :password,  String

  def can_sign_in?
    email.blank? || (user_with_email && user_with_email.encrypted_password?)
  end

  alias_method :email_address, :email

  def model_name
    ActiveModel::Name.new(User)
  end

  private

  def user_with_email
    return @user_with_email if @user_with_email
    return unless email

    @user_with_email = UserQuery.email_address(email)
  end
end
