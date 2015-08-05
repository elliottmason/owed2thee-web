class Transfer < ActiveRecord::Base
  include Transitional
  include Uuidable

  belongs_to :creator,  class_name: 'User'
  belongs_to :recipient,  polymorphic: true
  belongs_to :sender,     polymorphic: true
  has_many :groupings, as: :groupable
  has_many :groups, through: :groupings
  has_many :transfer_participants, as: :participable
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
