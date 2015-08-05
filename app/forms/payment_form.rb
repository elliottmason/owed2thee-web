class PaymentForm < BaseForm
  define_attributes initialize: true, attributes: true do
    attribute :amount, Float
  end

  validates :amount, numericality: { greater_than: 0.00 }
end
