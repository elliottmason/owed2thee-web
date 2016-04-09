class EmailAddressConfirmationQuery < TemporarySigninQuery
  def initialize(relation = EmailAddressConfirmation.all)
    super
  end
end
