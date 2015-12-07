class Transfer < ActiveRecord::Base
  include PublicActivity::Model
  include Transitional
  include Uuidable

  belongs_to :creator,    class_name: 'User'
  belongs_to :recipient,  class_name: 'User'
  belongs_to :sender,     class_name: 'User'
  has_many :transfer_email_addresses
  has_many :email_addresses, through: :transfer_email_addresses

  validate :obligors_must_not_be_identical
  validates :creator,   presence: true
  validates :recipient, presence: true
  validates :sender,    presence: true

  monetize :amount_cents

  transitional :confirmation, state_machine_class_name: 'DisputeStateMachine'
  transitional :publicity

  private

  def obligors_must_not_be_identical
    errors.add(
      :base,
      I18n.t(
        'transfers.errors.identical_obligors',
        record: self.class.name.underscore
      )
    ) if (recipient == sender)
  end
end
