class ConfirmUserContactsForTransfer < ApplicationService
  attr_reader :user
  attr_reader :transfer

  def initialize(transfer, user)
    @transfer = transfer
    @user     = user
  end

  def perform
    UserContactQuery.
      unconfirmed_for_source(contact: user, source: transfer).
      each(&:confirm!)
    @successful = true
  end
end
