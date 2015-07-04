FastAttributes.type_cast Float do
  from '', to: 0.0
  otherwise '%s.to_f'
end

class LoanForm < BaseForm
  include ActiveModel::Validations

  define_attributes initialize: true, attributes: true do
    attribute :amount,                  Float
    attribute :creator_email_address,   String
    attribute :obligor_email_address,   String
    attribute :type,                    String
  end

  validate :emails_unidentical
  validate :amount_positive
  validates :obligor_email_address, presence: true
  validates :type, inclusion: %w(debt loan)

  attr_writer :errors

  private

  def amount_positive
    errors.add(:base, I18n.t('errors.messages.nonpositive_amount')) \
      if amount <= 0
  end

  def emails_unidentical
    errors.add(:base,
               I18n.t('errors.messages.identical_users', record: 'loan')) \
      if creator_email_address == obligor_email_address && \
         !creator_email_address.blank?
  end
end
