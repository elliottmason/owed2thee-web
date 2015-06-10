FastAttributes.type_cast Integer do
  from '', to: 0
  otherwise '%s.to_i'
end

class LoanForm < BaseForm
  include ActiveModel::Validations

  validate :emails_unidentical
  validate :amount_positive
  validates :obligor_email, presence: true
  validates :type, inclusion: %w(debt loan)

  define_attributes initialize: true, attributes: true do
    attribute :amount_cents,    Integer
    attribute :amount_dollars,  Integer
    attribute :creator_email,   String
    attribute :obligor_email,   String
    attribute :type,            String
  end

  private

  def amount_positive
    errors.add(:base, I18n.t('errors.messages.nonpositive_amount')) \
      if amount_cents <= 0 && amount_dollars <= 0
  end

  def emails_unidentical
    errors.add(:base,
               I18n.t('errors.messages.identical_users', record: 'loan')) \
      if creator_email == obligor_email && !creator_email.nil?
  end
end
