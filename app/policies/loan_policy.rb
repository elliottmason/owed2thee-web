class LoanPolicy
  def initialize(user, loan)
    @user = user
    @loan = loan
  end

  def show?
    return false unless @user

    if @user.confirmed?
      related?
    else
      related? && recent?
    end
  end

  private

  def borrower?
    @loan.borrowers.include?(@user)
  end

  def creator?
    @loan.creator == @user
  end

  def lender?
    @loan.lenders.include?(@user)
  end

  def recent?
    @loan.created_at >= 1.day.ago
  end

  def related?
    creator? || lender? || borrower?
  end
end
