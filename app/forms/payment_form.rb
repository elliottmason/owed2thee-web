class PaymentForm < BaseForm
  attribute :amount, Float

  validates :amount, numericality: { greater_than: 0.00 }
end
