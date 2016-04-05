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

  def allowed?
    form.valid?
  end

  def form
    @form ||= PaymentForm.new(params)
  end

  def perform
    create_payment
  end

  def successful?
    payment && payment.persisted?
  end

  private

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
    payment.save!
  rescue ActiveRecord::RecordInvalid
    raise ActiveRecord::Rollback
  end
end
