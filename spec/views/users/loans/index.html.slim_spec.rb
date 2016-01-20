require 'rails_helper'

describe 'users/loans/index.html.slim' do
  include ApplicationHelper

  let(:activity) { loan.activities.where(recipient: loan.creator).first }
  let!(:borrower) do
    FactoryGirl.create(:confirmed_user,
                       email_address: borrower_email_address,
                       first_name: 'Josh',
                       last_name: 'Schramm')
  end
  let(:borrower_email_address) { 'josh.schramm@gmail.com' }
  let!(:creator) do
    FactoryGirl.create(:confirmed_user,
                       first_name: 'Elliott',
                       last_name: 'Mason')
  end
  let(:lender) { creator }
  let(:loan) do
    CreateLoan.with(creator, loan_form).loan
  end
  let(:loan_form) do
    FactoryGirl.attributes_for(
      :loan_form,
      amount: loan_amount,
      obligor_email_address: borrower_email_address
    )
  end
  let(:payee) { lender }
  let(:payer) { borrower }
  let!(:payment) do
    CreatePayment.with(
      payer,
      payee,
      FactoryGirl.attributes_for(:payment_form, amount: 1)
    ).payment
  end

  def assign_activities
    assign(
      :activities,
      GroupRecordsByCreationDate.with(
        ActivityQuery.for_user(current_user)
      )
    )
  end

  before do
    sign_in(current_user)

    PublishLoan.with(loan, loan.creator)
  end

  context 'as creator' do
    let(:current_user) { creator }

    context 'for a published, but disputed loan' do
      let(:loan_amount) { 40.00 }

      before do
        DisputeLoan.with(loan, loan.borrower)

        assign_activities
        render
      end

      it 'has creation item' do
        expect(rendered).to \
          have_content('you submitted a loan to josh.schramm@gmail.com for ' \
                       '$40.00')
      end

      it 'has dispute item' do
        expect(rendered).to \
          have_content('josh.schramm@gmail.com disputed your loan for $40.00')
      end
    end

    context 'for a confirmed loan and confirmed payment' do
      let(:loan_amount) { 9000.01 }

      before do
        ConfirmLoan.with(loan, loan.borrower)
        PublishPayment.with(payment, payment.creator)
        # DisputePayment.with(payment, payment.payee)
        ConfirmPayment.with(payment, payment.payee)

        assign_activities
        render
      end

      it 'has creation item' do
        expect(rendered)
          .to have_content('you submitted a loan to Josh Schramm for ' \
                           '$9,000.01')
      end

      it 'has confirmation item' do
        expect(rendered)
          .to have_content('Josh Schramm confirmed your loan to them for ' \
                           '$9,000.01')
      end

      it 'has payment item' do
        expect(rendered)
          .to have_content('Josh Schramm submitted a $1.00 payment')
      end
    end
  end

  context 'as participant' do
    let(:current_user) { borrower }
    let(:loan_amount) { 10 }

    before do
      DisputeLoan.with(loan, loan.borrower)
      ConfirmLoan.with(loan, loan.borrower)
      PublishPayment.with(payment, payment.payer)
      ConfirmPayment.with(payment, payment.payee)

      assign_activities
      render
    end

    it 'has creation item' do
      expect(rendered)
        .to have_content('Elliott Mason submitted a loan to you for $10.00')
    end

    it 'has dispute item' do
      expect(rendered)
        .to have_content("you disputed Elliott Mason's loan for $10.00")
    end

    it 'has confirmation item' do
      expect(rendered)
        .to have_content("you confirmed Elliott Mason's loan to you for $10.00")
    end

    it 'has payment item' do
      expect(rendered)
        .to have_content('you submitted a $1.00 payment to Elliott Mason')
    end

    it 'has payment confirmation item' do
      expect(rendered)
        .to have_content('Elliott Mason confirmed your $1.00 payment')
    end
  end
end
