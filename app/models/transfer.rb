class Transfer < ActiveRecord::Base
  include PublicActivity::Model
  include Transitional
  include Uuidable

  belongs_to :creator, class_name: 'User'
  belongs_to :recipient,  polymorphic: true
  belongs_to :sender,     polymorphic: true
  has_many :transfer_email_addresses
  has_many :email_addresses, through: :transfer_email_addresses
  has_many :groupings, as: :groupable
  has_many :groups, through: :groupings
  has_many :transfer_participants
  has_many :participants, class_name: 'User',
                          source:     :user,
                          through:    :transfer_participants

  validates :creator,   presence: true
  validates :recipient, presence: true
  validates :sender,    presence: true

  monetize :amount_cents

  transitional :confirmation
  transitional :publicity
end
