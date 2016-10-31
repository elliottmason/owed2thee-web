class Transfer < ActiveRecord::Base
  include PublicActivity::Model
  include Transitional
  include Uuidable

  belongs_to :creator,    class_name: 'User'
  belongs_to :recipient,  class_name: 'User'
  belongs_to :sender,     class_name: 'User'

  validate :participants_must_not_be_identical
  validates :creator,   presence: true
  validates :recipient, presence: true
  validates :sender,    presence: true

  before_create :set_default_balance

  monetize :amount_cents
  monetize :balance_cents

  state_machine :TransferStateMachine

  def participants
    [recipient, sender]
  end

  private

  def participants_must_not_be_identical
    errors.add(
      :base,
      I18n.t(
        'transfers.errors.identical_participants',
        record: self.class.name.underscore
      )
    ) if recipient == sender
  end

  def set_default_balance
    self[:balance_cents] = self[:amount_cents]
  end
end
