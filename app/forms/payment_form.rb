class PaymentForm < BaseForm
  define_attributes initialize: true, attributes: true do
    attribute :amount, Float
  end

  validate :amount_positive

  private

  def amount_positive
    errors.add(:base, I18n.t('errors.messages.nonpositive_amount')) \
      if amount <= 0
  end
end
