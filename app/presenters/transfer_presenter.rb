class TransferPresenter < BasePresenter
  def activities
    @activities ||= loan.activities.where(recipient: viewer)
  end

  def amount
    amount_for(transfer)
  end

  def amount_lent
    return unless loan

    amount_for(loan)
  end

  def creator
    @creator ||= display_name(transfer.creator)
  end

  def display_name(user, possessive: false)
    UserPresenter.
      new(user, viewer, transfer).
      display_name(possessive: possessive)
  end

  alias transfer item

  private

  def amount_for(object)
    object.amount.format
  end
end
