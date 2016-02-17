class LoanRequest < ActiveRecord::Base
  include Uuidable

  belongs_to :creator, class_name: 'User'

  has_many :loans

  validate :disbursement_deadline_must_be_future
  validate :repayment_deadline_must_be_after_disbursement
  validates :amount_requested, numericality: { greater_than: 0.0 }
  validates :creator, presence: true

  private

  def disbursement_deadline_must_be_future
    return unless disbursement_deadline.present?

    must_be_future(:disbursement_deadline)
  end

  # TODO: wish I didn't have to hardcode the offset
  def must_be_future(name, offset = 1.day)
    if self[name] < Time.zone.today + offset
      errors.add(:repayment_deadline, 'must be at least a day from now')
    end
  end

  def repayment_deadline_must_be_after_disbursement
    return unless repayment_deadline.present?

    if disbursement_deadline &&
       repayment_deadline < disbursement_deadline + 1.day
      errors.add(:repayment_deadline, 'must be at least a day from the day of' \
        ' disbursement')
    else
      must_be_future(:repayment_deadline)
    end
  end
end
