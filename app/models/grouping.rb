class Grouping < ActiveRecord::Base
  belongs_to :group
  belongs_to :groupable, polymorphic: true

  validates :group,     presence: true
  validates :groupable, presence: true
end
