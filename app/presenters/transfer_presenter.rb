class TransferPresenter < BasePresenter
  def amount
    amount_for(item)
  end

  def amount_lent
    amount_for(loan)
  end

  def creator
    return @creator if @creator

    @creator ||= 'your' if viewer == transfer.creator
    @creator ||= UserPresenter.new(transfer.creator, viewer, transfer)
                 .display_name
  end

  alias_method :transfer, :item

  private

  def amount_for(object)
    object.amount.format
  end
end
