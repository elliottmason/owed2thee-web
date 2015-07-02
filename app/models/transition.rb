class Transition < ActiveRecord::Base
  belongs_to :transitional, polymorphic: true
end
