class CreatePayment < BaseService
  def initialize(creator, loan, params = {})
    @creator  = creator
    @loan     = loan
    @params   = params
  end

  attr_reader :creator

  def create_payment
    payment.payees = payees
    payment.payers = payers
    payment.save
  end

  def form
    @form ||= PaymentForm.new(params)
  end

  attr_reader :loan

  attr_reader :params

  def payees
    loan.lenders
  end

  def payers
    [@creator]
  end

  def payment
    @payment ||= Payment.new do |payment|
      payment.creator = creator
      payment.payable = loan
      payment.payer   = creator
      payment.amount  = form.amount
    end
  end

  def perform
    return unless form.valid?

    @successful = create_payment
  end

  attr_reader :user
end
