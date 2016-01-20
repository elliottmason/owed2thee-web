class UserPolicy < ApplicationPolicy
  def initialize(current_user, target_user = nil, loan = nil)
    @current_user = current_user
    @target_user  = target_user
    @loan         = loan
  end

  def pay?
    ledger && ledger.payable?(current_user)
  end

  def sign_in?
    current_user.nil? && target_user.encrypted_password?
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
    @ledger ||= LedgerQuery.between!(current_user, target_user)
  end
end
