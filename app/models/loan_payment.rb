class LoanPayment < ActiveRecord::Base
  belongs_to :loan
  belongs_to :payment

  monetize :amount_cents
end
