class Transfer < ActiveRecord::Base
  include Transitional

  belongs_to :creator,  class_name: 'User'
  belongs_to :recipient,  polymorphic: true
  belongs_to :sender,     polymorphic: true
  has_many :groupings, as: :groupable
  has_many :groups, through: :groupings
  has_many :transfer_participants
  has_many :participants, class_name: 'User',
                          through: :transfer_participants

  validates :amount_cents, numericality: { greater_than: 0 }
  validates :creator,     presence: true

  monetize :amount_cents

  transitional :confirmation
  transitional :publicity
end
