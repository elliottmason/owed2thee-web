class CommentQuery < ApplicationQuery
  def initialize(relation = Comment.all)
    super
  end

  def self.description_for_loan(loan)
    new.relation.
      where(commentable: loan).
      order("type = 'LoanDescription', type = 'LoanComment'").
      order('created_at ASC').
      first
  end

  module Scopes
  end
end
