class LoanQuery < BaseQuery
  PER_PAGE = 15

  attr_reader :relation

  def initialize
    super(Loan.all)
  end

  def self.paginated_for_user(user, page = 1)
    new
      .relation
      .published
      .user(user)
      .page(page, PER_PAGE)
      .order('transfers.created_at DESC')
  end

  def self.uuid(uuid)
    Loan.where(uuid: uuid).first!
  end

  module Scopes
    include Paginated

    def published
      in_state(:published)
    end

    def user(user)
      where(
        'recipient_id = ? OR creator_id = ? OR sender_id = ?',
        *([user] * 3)
      )
    end
  end
end
