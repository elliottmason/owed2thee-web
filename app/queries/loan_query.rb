class LoanQuery
  PER_PAGE = 15

  def initialize(relation = Loan.all)
    @relation = relation.extending(Scopes)
  end

  def self.paginated_for_user(user, page = nil)
    new.relation  \
      .published  \
      .user(user) \
      .page(page) \
      .eager_load(:transitions) \
      .order('transfers.created_at DESC')
  end

  def page

  end

  attr_reader :relation

  module Scopes
    def page(page, per_page = PER_PAGE)
      limit = per_page
      offset = (page - 1) * per_page

      limit(limit).offset(offset)
    end

    def published
      in_state(:published)
    end

    def user(user)
      joins(:transfer_participants) \
        .where(transfer_participants: { user_id: user.id })
    end
  end
end
