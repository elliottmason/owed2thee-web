class PaymentForm < ApplicationForm
  attribute :amount,    Float

  validates :amount, numericality: { greater_than: 0.00 }
end
