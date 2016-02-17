class SignInForm < ApplicationForm
  include Lean::Attributes

  attribute :email,     String
  attribute :password,  String

  alias_method :email_address, :email

  def model_name
    ActiveModel::Name.new(User)
  end
end
