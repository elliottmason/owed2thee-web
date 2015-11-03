# Loan is a payable type of Transfer. A Loan is published when the creator
# confirms in it, and is confirmed when all LoanParticipants have confirmed
# the Loan. Loans can theoretically have multiple LoanBorrowers and LoanLenders.
# Payments are applied toward a Loan to satisfy its payment status, although
# the Loan can be absolved by the LoanLenders for any reason(s), which is
# equivalent.
class Loan < Transfer
  # has_many :through definitions must remain in this order until this issue is
  # resolved: https://github.com/rails/rails/issues/16139
  belongs_to :borrower, foreign_key:  'recipient_id',
                        foreign_type: 'recipient_type',
                        polymorphic:  true
  belongs_to :lender,   foreign_key:  'sender_id',
                        foreign_type: 'sender_type',
                        polymorphic:  true
  has_many :loan_borrowers, foreign_key: 'transfer_id'
  has_many :borrowers, class_name: 'User', through: :loan_borrowers
  has_many :comments, as: :commentable
  has_many :loan_lenders, foreign_key: 'transfer_id'
  has_many :lenders, class_name: 'User', through: :loan_lenders

  validate :borrowers_must_not_be_lenders
  validates :borrowers, presence: true
  validates :lenders,   presence: true

  transitional :payment

  alias_method :loan_participants, :transfer_participants

  private

  def borrowers_must_not_be_lenders
    errors.add(:base, I18n.t('loans.errors.identical_users', 'loan')) \
      if (borrowers & lenders).any?
  end
end
