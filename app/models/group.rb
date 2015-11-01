class Group < ActiveRecord::Base
  has_many :groupings

  # TODO: why did I use STI?
  monetize :confirmed_amount_cents
  monetize :projected_amount_cents
end
