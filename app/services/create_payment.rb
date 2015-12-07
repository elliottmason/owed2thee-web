class CreatePayment < BaseService
  include Wisper::Publisher

  attr_reader :creator
  attr_reader :loan
  attr_reader :params
  attr_reader :payment
  attr_reader :user

  def initialize(creator, loan, params = {})
    @creator  = creator
    @loan     = loan
    @params   = params

    subscribe(PaymentListener.new)
  end

  def form
    @form ||= PaymentForm.new(params)
  end

  def perform
    return unless form.valid?

    @successful = create_payment

    broadcast(:create_payment_successful, payment)
  end

  private

  def build_payment
    @payment = Payment.new do |payment|
      payment.creator = creator
      payment.payee   = loan.lender
      payment.payer   = creator
      payment.amount  = form.amount
    end
  end

  def create_payment
    build_payment
    payment.save
  end
end
