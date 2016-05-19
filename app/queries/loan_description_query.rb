class LoanDescriptionQuery < CommentQuery
  def initialize(relation = LoanDescription.all)
    super
  end

  def self.exists_for?(loan)
    new.relation.where(commentable: loan).exists?
  end
end
