class UserPolicy < ApplicationPolicy
  def initialize(current_user, target_user = nil, loan = nil)
    @current_user = current_user
    @target_user  = target_user
    @loan         = loan
  end

  def pay?
    ledger && ledger.confirmed_balance(user).nonzero?.is_a?(Money)
  end

  def sign_in?
    return false if current_user.is_a?(User)
    return false if target_user.is_a?(User) && !target_user.encrypted_password?
    true
  end

  def sign_out?
    current_user.present?
  end

  def view_name?
    (loan && loan.creator_id == target_user.id) ||
      UserContactQuery.between(current_user, target_user).exists?
  end

  private

  attr_reader :current_user
  attr_reader :loan
  attr_reader :target_user

  def ledger
    @ledger ||= LedgerQuery.first_between(current_user, target_user)
  end
end
