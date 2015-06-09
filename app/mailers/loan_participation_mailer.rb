class LoanParticipationMailer < ApplicationMailer
  default from: 'notifications@owed2thee.com'

  def confirmation_link
    if recipient.confirmed?
      url_for([loan])
    else
      url_for([
        :confirm, :account, recipient_email,
        { confirmation_token: recipient_email.confirmation_token }
      ])
    end
  end

  def email(participant)
    @participant        = participant
    @confirmation_link  = confirmation_link
    mail(to: to, subject: subject)
  end


  private

  def creator
    loan.creator
  end

  def creator_email
    creator.emails.first
  end

  def loan
    @loan ||= participant.loan
  end

  attr_reader :participant

  def recipient_email
    @recipient_email ||= recipient.emails.first
  end

  def subject
    '[Owed2Thee] - Confirm or deny your loan with ' + creator_email.email
  end

  def to
    recipient_email.email
  end

  def recipient
    @recipient ||= participant.user
  end
end
