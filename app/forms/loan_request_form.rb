class LoanRequestForm < ApplicationForm
  attribute :amount_requested,      Float
  attribute :disbursement_deadline, Time
  attribute :repayment_deadline,    Time

  def coerce_time(value)
    nil if value.empty?
  end
  alias coerce_disbursement_deadline coerce_time
  alias coerce_repayment_deadline coerce_time
end
