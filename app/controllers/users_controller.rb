class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :retrieve_user, only: %i(show)
  before_action :authorize_user

  helper_method :user

  def show
    retrieve_transfers
  end

  private

  def authorize_user
    authorize(@user)
  end

  def retrieve_transfers
    @confirmed_transfers = Burgundy::Collection.new(
      TransferQuery.confirmed_between(current_user, @user),
      Users::TransferPresenter,
      current_user
    )
    @unconfirmed_transfers = Burgundy::Collection.new(
      TransferQuery.unconfirmed_between(current_user, @user),
      Users::TransferPresenter,
      current_user
    )
  end

  def retrieve_user
    @user = UserQuery.uuid!(params[:uuid])
  end

  def user
    @presented_user = UserPresenter.new(@user, current_user)
  end
end
