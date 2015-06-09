class UserEmail < ActiveRecord::Base
  include Confirmable
  include ConfirmationToken

  belongs_to :user

  validates :email, uniqueness: { conditions: -> { in_state(:confirmed) } },
                    format: { with: /.+@.+\..+/, on: :create }

  def to_param
    email
  end
end
