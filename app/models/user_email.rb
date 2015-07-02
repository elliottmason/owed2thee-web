# A User can have multiple email addresses associated with his or her account.
# Each UserEmail record contains a unique email address and the model contains
# a state machine that tracks its confirmation status.
class UserEmail < ActiveRecord::Base
  include Transitional

  belongs_to :user

  validates :email, format: { with: /.+@.+\..+/, on: :create },
                    uniqueness: { conditions: -> { in_state(:confirmed) } }

  transitional :confirmation

  # must be included after transitional to override #confirm!
  include ConfirmationToken

  alias_method :address,  :email
  alias_method :address=, :email=

  def to_param
    email
  end
end
