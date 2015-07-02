class ForgotPasswordForm < BaseForm
  define_attributes initialize: true, attributes: true do
    attribute :email, String
  end
end
