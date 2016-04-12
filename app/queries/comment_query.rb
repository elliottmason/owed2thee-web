class CommentQuery < ApplicationQuery
  def initialize(relation = Comment.all)
    super
  end

  def self.description_for_loan(loan)
    new.relation.
      where(commentable: loan).
      commenter(loan.creator).
      where('commenter_id IS NOT NULL').
      where_values.inject(:or).
      first
  end

  module Scopes
    def commenter(user)
      where(commenter: user)
    end
  end
end
