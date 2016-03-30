class EmailAddressConfirmation < TemporarySignin
  def initialize(relation = EmailAddressConfirmation.all)
    super
  end
end
