class ChangeUserPassword < BaseService
  attr_reader :form

  def initialize(user, params)
    @user = user
    @form = PasswordForm.new(params.merge(user: user))
  end

  delegate :current_password, :new_password, :new_password_confirmation,
           to: :form

  def perform
    return unless user.valid_password?(current_password) &&
                  new_password == new_password_confirmation

    user.password = new_password
    @successful = user.save
  end

  def successful?
    @successful
  end

  private

  attr_reader :user
end
