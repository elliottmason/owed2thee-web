class PublishLoan < BaseService
  include Wisper::Publisher

  attr_reader :force
  attr_reader :loan

  def initialize(loan = nil, force = false)
    @force  = force
    @loan   = loan

    subscribe(LoanListener.new)
  end

  def confirmed_by_creator?
    TransferParticipantQuery.confirmed_creator_for(loan).exists?
  end

  alias_method :force?, :force

  def perform
    return unless confirmed_by_creator? || force?

    @successful = @loan.publish!

    broadcast(:publish_loan_successful, @loan) if successful?
  end
end
