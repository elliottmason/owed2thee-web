class TransferPresenter < BasePresenter
  def amount
    amount_for(item)
  end

  def amount_lent
    amount_for(loan)
  end

  def borrowers
    return @borrowers if @borrowers

    @borrowers ||= join_display_names(loan.borrowers)
  end

  def creator
    return @creator if @creator

    @creator = UserPresenter.new(transfer.creator, viewer, transfer)
               .display_name
  end

  def lenders
    return @lenders if @lenders

    @lenders ||= join_display_names(loan.lenders)
  end

  alias_method :transfer, :item

  private

  def amount_for(object)
    object.amount.format
  end

  def join_display_names(users)
    Burgundy::Collection.new(
      users,
      UserPresenter,
      viewer,
      loan
    ).map(&:display_name).join(', ')
  end
end
