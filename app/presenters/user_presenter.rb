class UserPresenter < Burgundy::Item
  alias user item

  def initialize(user, viewer, transfer = nil)
    super(user)
    @viewer   = viewer
    @transfer = transfer
  end

  def contact_display_name
    return unless contact

    contact.display_name
  end

  def contact_fallback_display_name
    return unless contact

    contact.fallback_display_name
  end

  def debted?
    ledger.confirmed_balance(viewer).negative?
  end

  def display_name(possessive: false)
    return @display_name if @display_name

    if user_is_viewer? && transfer
      @display_name = possessive ? 'your' : 'you'
    else
      @display_name = determine_display_name
      @display_name += "'s" if possessive
    end

    @display_name
  end

  def ledger?
    ledger.present?
  end

  private

  attr_reader :viewer
  attr_reader :transfer

  def can_view_full_name?
    return false unless viewer

    UserPolicy.new(viewer, user, transfer).view_name?
  end
  alias can_view_primary_email_address? can_view_full_name?

  def contact
    return @contact if defined?(@contact)

    UserContactQuery.first_confirmed_for(contact: user, owner: viewer)
  end

  def determine_display_name
    contact_display_name ||
      full_name ||
      primary_email_address ||
      transfer_contact_name ||
      contact_fallback_display_name ||
      I18n.t('app.default_display_name')
  end

  def full_name
    return @full_name if defined?(@full_name)

    return unless user.first_name.present? || user.last_name.present?
    return unless can_view_full_name?

    @full_name = [user.first_name, user.last_name].compact.join(' ')
  end

  def ledger
    return @ledger if defined?(@ledger)

    @ledger = LedgerQuery.first_between(user, viewer)
  end

  def primary_email_address
    return unless can_view_full_name?

    user.primary_email_address.address
  end

  def transfer_contact_name
    return unless transfer

    transfer.contact_name
  end

  def user_is_viewer?
    user.is_a?(viewer.class) && user.id == viewer.id
  end
end
