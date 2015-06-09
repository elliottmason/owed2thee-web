class LoanParticipationMailer < ApplicationMailer
  default from: 'notifications@owed2thee.com'

  def confirmation_link
    if recipient.confirmed?
      confirm_loan_participation_path(participant)
    else
      confirm_user_email_path(recipient_email)
    end
  end

  def email(participant)
    @participant = participant
    mail(to: recipient_email, subject: subject)
  end

  private

  def creator
    loan.creator
  end

  def loan
    @loan ||= participant.loan
  end

  attr_reader :participant

  def recipient_email
    @recipient_email ||= user.email
  end

  def subject
    '[Owed2Thee] - Confirm or deny your loan with ' + creator.email
  end

  def recipient
    @recipient ||= participant.user
  end
end
