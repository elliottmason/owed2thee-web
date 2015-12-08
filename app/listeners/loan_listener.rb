class LoanListener
  def create_loan_successful(_loan)
  end

  def confirm_loan_successful(loan, user)
    CreateUserContactsForTransferParticipant.with(loan, user)
    RecordTransferActivity.with(loan, :confirmed, user)
  end

  def dispute_loan_successful(loan, user)
    RecordTransferActivity.with(loan, :disputed, user)
  end

  def publish_loan_successful(loan, user)
    CreateLedgersForLoanParticipant.with(loan, user)
    CreateUserContactsForTransferParticipant.with(loan, user)
    NotifyLoanParticipants.with(loan)
    RecordTransferActivity.with(loan, :created)
  end
end

# class LoanParticipationListener
#   def confirm_loan_participation_successful(user, loan)
#     ConfirmLoan.with(loan)
#     PublishLoan.with(loan)
#     CreateLedgersForLoanParticipant.with(user, loan)
#     CreateUserContactsForTransferParticipant.with(user, loan)
#     RecordTransferActivity.with(user, loan, :confirmed) \
#       unless loan.creator_id == user.id
#   end
#
#   def dispute_loan_participation_successful(user, loan)
#     RecordTransferActivity.with(user, loan, :disputed)
#   end
# end
