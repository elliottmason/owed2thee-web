class LoanListener
  def create_loan_successful(_loan)
    # record creator "started" a loan?
  end

  def publish_loan_successful(loan)
    # TODO: I can see this getting repetitive. Create a service?
    loan.participants.each do |loan_participant|
      loan.create_activity(action:    :created,
                           owner:     loan.creator,
                           recipient: loan_participant)
    end

    NotifyUnconfirmedLoanParticipants.with(loan)
  end
end
