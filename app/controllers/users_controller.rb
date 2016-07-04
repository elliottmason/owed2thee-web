class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :retrieve_user, only: %i(show)
  before_action :authorize_user

  helper_method :user

  def show
  end

  private

  def authorize_user
    authorize(@user)
  end

  def retrieve_user
    @user = UserQuery.uuid!(params[:uuid])
  end

  def user
    @presented_user = UserPresenter.new(@user, current_user)
  end
end
