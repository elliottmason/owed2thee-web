class TransferPresenter < ApplicationPresenter
  def amount
    amount_for(transfer)
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
