class LoanRequest < ActiveRecord::Base
  belongs_to :creator, class_name: 'User'

  has_many :loans

  validate :disbursal_deadline_must_be_future
  validate :repayment_deadline_must_be_after_disbursal
  validates :creator, presence: true

  private

  def disbursal_deadline_must_be_future
    return unless disbursal_deadline.present?

    must_be_future(:disbursal_deadline)
  end

  # TODO: wish I didn't have to hardcode the offset
  def must_be_future(name, offset = 1.day)
    if self[name] < Time.zone.today + offset
      errors.add(:repayment_deadline, 'must be at least a day from now')
    end
  end

  def repayment_deadline_must_be_after_disbursal
    return unless repayment_deadline.present?

    if disbursal_deadline && repayment_deadline < disbursal_deadline + 1.day
      errors.add(:repayment_deadline, 'must be at least a day from the day of' \
        ' disbursement')
    else
      must_be_future(:repayment_deadline)
    end
  end
end
