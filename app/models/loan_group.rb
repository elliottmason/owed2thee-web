class LoanGroup < ActiveRecord::Base
  has_many :loans
end
