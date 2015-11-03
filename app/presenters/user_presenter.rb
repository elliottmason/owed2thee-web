class UserPresenter < Burgundy::Item
  alias_method :user, :item

  def initialize(user, viewer, transfer)
    super(user)
    @viewer   = viewer
    @transfer = transfer
  end

  def can_view_full_name?
    return false unless viewer

    full_name && UserPolicy.new(viewer, user, transfer).view_name?
  end

  def display_name
    return @display_name if @display_name

    @display_name = 'you' if viewer && user.id == viewer.id
    @display_name ||= full_name if can_view_full_name?

    @display_name ||= email_address
    @display_name ||= I18n.t('app.default_user')
  end

  def email_address
    return @email_address if @email_address

    @email_address = EmailAddressQuery.for_transfer_participant(transfer, user)
                     .address
  end

  def full_name
    return @full_name if @full_name

    return unless user.first_name.present? && user.last_name.present?
    @full_name = "#{user.first_name} #{user.last_name}"
  end

  private

  attr_reader :viewer
  attr_reader :transfer
end