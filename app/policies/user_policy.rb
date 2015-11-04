class UserPolicy
  def initialize(current_user, target_user, loan = nil)
    @current_user = current_user
    @target_user  = target_user
    @loan         = loan
  end

  # For privacy reasons, prevent
  def view_name?
    (loan && loan.creator_id == target_user.id) ||
      UserContactQuery.between(current_user, target_user).exists?
  end

  private

  attr_reader :current_user
  attr_reader :loan
  attr_reader :target_user
end
