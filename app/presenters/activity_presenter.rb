class ActivityPresenter < TransferPresenter
  delegate :created_at, :key, :text, :trackable, to: :activity

  alias_method :activity, :item

  def actor
    @actor ||= UserPresenter.new(activity.owner, viewer, loan)
               .display_name
  end

  def amount_lent
    loan.amount.format
  end

  def borrowers
    return @borrowers if @borrowers

    @borrowers ||= 'you'  if viewer == loan.borrower
    @borrowers ||= 'them' if loan.borrower == activity.owner
    @borrowers ||= join_display_names(loan.borrowers)
  end

  def lenders
    @lenders ||= '' if loan.lender == activity.owner

    super
  end

  alias_method :loan, :trackable
end
