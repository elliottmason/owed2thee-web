class UserEmail < ActiveRecord::Base
  include Transitional
  include ConfirmationToken

  belongs_to :user

  validates :email, uniqueness: { conditions: -> { in_state(:confirmed) } },
                    format: { with: /.+@.+\..+/, on: :create }

  transitional :confirmation

  def to_param
    email
  end
end
