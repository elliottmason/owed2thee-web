# A User can have multiple email addresses associated with his or her account.
# Each EmailAddress record contains a unique email address and the model
# contains a state machine that tracks its confirmation status.
class EmailAddress < ActiveRecord::Base
  include Transitional

  belongs_to :user
  has_many :confirmations, class_name: 'EmailAddressConfirmation'

  validates :address, format: { with: /.+@.+\..+/, on: :create }

  state_machine :EmailAddressStateMachine
end
