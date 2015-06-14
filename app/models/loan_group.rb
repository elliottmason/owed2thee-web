class LoanGroup < Group
  has_many :loans, source: :groupable, source_type: 'Loan', through: :groupings
end
