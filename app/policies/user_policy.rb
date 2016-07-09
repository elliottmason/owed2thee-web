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
    current_user == target_user || ledger.present?
  end

  def view_name?
    current_user == target_user ||
      (loan && loan.creator_id == target_user.id) ||
      UserContactQuery.confirmed_for(contact: target_user, owner: current_user).
        exists?
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
