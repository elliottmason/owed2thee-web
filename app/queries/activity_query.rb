class ActivityQuery < ApplicationQuery
  include Kaminari::ConfigurationMethods

  paginates_per 10

  def initialize
    super(PublicActivity::Activity.all)
  end

  def self.for_user(user)
    new
      .relation
      .recipient(user)
      .order('activities.created_at DESC')
  end

  module Scopes
    def recipient(user)
      where(recipient: user)
    end
  end
end
