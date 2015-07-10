class ChangeUserPassword < BaseService
  attr_reader :form
  attr_reader :user

  def initialize(user, params)
    @user   = user
    @params = params
  end

  delegate :current_password, :new_password, :new_password_confirmation,
           to: :form

  def form
    @form ||= PasswordForm.new(@params)
  end

  def perform
    return unless form.valid?
    return unless user.no_password? || user.valid_password?(current_password)

    user.password = new_password
    @successful = user.save
  end
end
