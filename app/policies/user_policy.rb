class UserPolicy < ApplicationPolicy
  def initialize(current_user, target_user = nil, loan = nil)
    @current_user = current_user
    @target_user  = target_user
    @loan         = loan
  end

  def pay?
    ledger && ledger.confirmed_balance(user).nonzero?.is_a?(Money)
  end

  def view_name?
    (loan && loan.creator_id == target_user.id) ||
      UserContactQuery.between(current_user, target_user).exists?
  end

  private

  attr_reader :loan

  def current_user
    @current_user if @current_user.is_a?(User)
  end

  def ledger
    @ledger ||= LedgerQuery.first_between(current_user, target_user)
  end

  def target_user
    @target_user if @target_user.is_a?(User)
  end
end
