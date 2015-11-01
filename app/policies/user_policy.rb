class UserPolicy
  def initialize(current_user, target_user)
    @current_user = current_user
    @target_user  = target_user
  end

  def view_name?
    Ledger.between(current_user, target_user).exists?
  end

  private

  attr_reader :current_user
  attr_reader :target_user
end
