class PaymentForm < BaseForm
  define_attributes initialize: true, attributes: true do
    attribute :amount_cents,    Integer
    attribute :amount_dollars,  Integer
  end

  validate :amount_positive

  def self.model_name
    ActiveModel::Name.new(Payment)
  end

  private

  def amount_positive
    errors.add(:base, I18n.t('errors.messages.nonpositive_amount')) \
      if amount_cents <= 0 && amount_dollars <= 0
  end
end
