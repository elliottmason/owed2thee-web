class SignInForm < BaseForm
  define_attributes initialize: true, attributes: true do
    attribute :email,     String
    attribute :password,  String
  end

  def model_name
    ActiveModel::Name.new(User)
  end
end
