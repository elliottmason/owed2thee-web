class UserPolicy < ApplicationPolicy
  def initialize(current_user, target_user = nil, loan = nil)
    @current_user = current_user
    @target_user  = target_user
    @loan         = loan
  end

  def pay?
    ledger.present? && ledger.confirmed_balance(user).nonzero?.is_a?(Money)
  end

  def show?
    true
  end

  def view_name?
    current_user == target_user ||
      (loan && loan.creator_id == target_user.id) ||
      contact_confirmed?
  end

  private

  attr_reader :loan

  def contact_confirmed?
    UserContactQuery.
      confirmed_between?(contact: target_user, owner: current_user)
  end

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
