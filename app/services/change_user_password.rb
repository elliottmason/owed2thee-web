class ChangeUserPassword < ApplicationService
  delegate :current_password, :new_password, :new_password_confirmation,
           :password_reset,
           to: :form

  def initialize(user, params)
    @user   = user
    @params = params
  end

  def allowed?
    form.valid?
  end

  def form
    return @form if @form

    @form = PasswordForm.new(@params, @user)
  end

  def perform
    ActiveRecord::Base.transaction do
      user.password = new_password
      redeem_password_reset
    end
    @successful = user.save
  end

  def user
    @user ||= form.user
  end

  private

  def redeem_password_reset
    return unless password_reset

    RedeemPasswordReset.with(password_reset)
  end
end
