class LoanParticipationMailer < ApplicationMailer
  default from: 'notifications@owed2thee.com'

  def confirmation_link
    if recipient.confirmed?
      url_for([loan])
    else
      url_for([
        :confirm, :user, recipient_email_address,
        { confirmation_token: recipient_email_address.confirmation_token }
      ])
    end
  end

  def email(loan, recipient)
    @loan               = loan
    @recipient          = recipient
    @confirmation_link  = confirmation_link
    mail(to: to, subject: subject)
  end

  private

  attr_reader :loan
  attr_reader :recipient

  def creator
    loan.creator
  end

  def creator_email_address
    creator.primary_email_address
  end

  def recipient_email_address
    @recipient_email_address ||= recipient.primary_email_address
  end

  def subject
    '[Owed2Thee] - Confirm or deny your loan with ' +
      creator_email_address.address
  end

  def to
    recipient_email_address.address
  end
end
