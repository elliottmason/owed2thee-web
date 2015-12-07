# A User can have multiple email addresses associated with his or her account.
# Each EmailAddress record contains a unique email address and the model
# contains a state machine that tracks its confirmation status.
class EmailAddress < ActiveRecord::Base
  include ConfirmationToken
  include Transitional

  belongs_to :user

  validates :address, format:     { with: /.+@.+\..+/, on: :create },
                      uniqueness: { conditions: -> { in_state(:confirmed) } }

  transitional :confirmation

  def to_param
    address
  end
end
