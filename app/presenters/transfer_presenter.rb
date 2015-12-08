class TransferPresenter < BasePresenter
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
    result = UserPresenter
             .new(user, viewer, transfer)
             .display_name(possessive: possessive)
  end

  alias_method :transfer, :item

  def viewer_is?(type)
    transfer.send(type) == viewer
  end

  private

  def amount_for(object)
    object.amount.format
  end
end
