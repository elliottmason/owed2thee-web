class UserEmail < ActiveRecord::Base
  include Transitional

  belongs_to :user

  validates :email, uniqueness: { conditions: -> { in_state(:confirmed) } },
                    format: { with: /.+@.+\..+/, on: :create }

  transitional :confirmation

  include ConfirmationToken

  def to_param
    email
  end
end
