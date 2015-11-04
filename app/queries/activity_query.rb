class ActivityQuery < BaseQuery
  PER_PAGE = 15

  def initialize
    super(PublicActivity::Activity.all)
  end

  def self.paginated_for_user(user, page = 1)
    new
      .relation
      .recipient(user)
      .page(page, PER_PAGE)
      .order('activities.created_at DESC')
  end

  module Scopes
    include Paginated

    def recipient(user)
      where(recipient: user)
    end
  end
end
