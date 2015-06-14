class Group < ActiveRecord::Base
  has_many :groupings

  monetize :confirmed_amount_cents
  monetize :projected_amount_cents
end
