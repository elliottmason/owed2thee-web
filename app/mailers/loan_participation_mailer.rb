class LoanParticipationMailer < ApplicationMailer
  delegate :amount,
           :confirmation_link,
           :creator,
           :loan_type,
           :verb,
           to: :presenter

  def email(loan, recipient)
    @loan       = loan
    @recipient  = recipient
    @presenter  = presenter
    mail(to: to, subject: @presenter.subject)
  end

  private

  attr_reader :loan
  attr_reader :recipient

  def presenter
    @presenter ||= LoanParticipationMailerPresenter.new(loan, recipient)
  end

  def recipient_email_address
    @recipient_email_address ||= recipient.primary_email_address
  end

  def to
    recipient_email_address.address
  end
end
