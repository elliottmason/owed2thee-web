class ChangeUserPassword < ApplicationService
  attr_reader :form
  attr_reader :user

  def initialize(user, params)
    @user   = user
    @params = params
  end

  delegate :current_password, :new_password, :new_password_confirmation,
           to: :form

  def form
    return @form if @form

    @form = PasswordForm.new(@params)
    @form.require_current_password  = user.password?
    @form.current_password_valid    = user.valid_password?(current_password)
    @form
  end

  def perform
    return unless form.valid?

    user.password = new_password
    @successful = user.save
  end
end
