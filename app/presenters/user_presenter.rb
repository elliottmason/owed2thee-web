class UserPresenter < Burgundy::Item
  alias_method :user, :item

  def initialize(user, current_user, loan)
    super(user)
    @current_user = current_user
    @loan         = loan
  end

  def can_view_full_name?
    full_name && UserPolicy.new(user, current_user).view_name?
  end

  def display_name
    return @display_name if @display_name

    @display_name = 'you' if user.id == current_user.id
    @display_name ||= full_name if can_view_full_name?
    @display_name ||= email_address
    @display_name ||= I18n.t('app.default_user')
  end

  def email_address
    return @email_address if @email_address

    @email_address = EmailAddressQuery.for_loan_participant(loan, user).address
  end

  def full_name
    return @full_name if @full_name

    return unless user.first_name.present? && user.last_name.present?
    @full_name = "#{user.first_name} #{user.last_name}"
  end

  private

  attr_reader :current_user
  attr_reader :loan
end
