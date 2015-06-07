class UserEmail < ActiveRecord::Base
  include Confirmable

  belongs_to :user

  validates :email, uniqueness:
                    {
                      conditions: -> { where('confirmed_at IS NOT NULL') }
                    },
                    format: { with: /.+@.+\..+/, on: :create }
end
