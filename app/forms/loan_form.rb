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

  validate :emails_most_not_be_identical
  validates :amount, numericality: { greater_than: 0.00 }
  validates :obligor_email_address, presence: true
  validates :type, inclusion: %w(debt loan)

  attr_writer :errors

  private

  def emails_identical?
    creator_email_address == obligor_email_address &&
      !creator_email_address.blank?
  end

  def emails_most_not_be_identical
    errors.add(:base, I18n.t('loans.errors.identical_users')) \
      if emails_identical?
  end
end
