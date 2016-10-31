module UsersHelper
  def confirmed_transfers
    @confirmed_transfers ||= Burgundy::Collection.new(
      TransferQuery.confirmed_between(current_user, @user),
      Users::TransferPresenter,
      current_user
    )
    @confirmed_transfers
  end

  def unconfirmed_transfers
    @unconfirmed_transfers ||= Burgundy::Collection.new(
      TransferQuery.unconfirmed_between(current_user, @user),
      Users::TransferPresenter,
      current_user
    )
  end

  def user
    @presented_user ||= UserPresenter.new(@user, current_user)
  end
end
