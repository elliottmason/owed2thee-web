class CreatePayment < ApplicationService
  include BroadcastToListeners

  attr_reader :creator
  attr_reader :params
  attr_reader :payee
  attr_reader :payment
  attr_reader :user

  subscribe :PaymentListener

  def initialize(creator, payee, params = {})
    @creator  = creator
    @params   = params
    @payee    = payee
  end

  def form
    @form ||= PaymentForm.new(params)
  end

  def perform
    return unless form.valid?

    create_payment
    @successful = payment.persisted?
    super
  end

  private

  def broadcast_to_listeners
    broadcast(:create_payment_successful, payment)
  end

  def build_payment
    @payment = Payment.new do |payment|
      payment.amount  = form.amount
      payment.creator = creator
      payment.payee   = payee
      payment.payer   = creator
    end
  end

  def create_payment
    build_payment
    payment.save
  end
end
