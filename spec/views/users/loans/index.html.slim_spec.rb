require 'spec_helper'

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

  def assign_activities
    assign(
      :activities,
      GroupRecordsByCreationDate.with(
        ActivityQuery.paginated_for_user(current_user, 1)
      )
    )
  end

  before do
    sign_in(current_user)
    ConfirmLoanParticipation.for(creator, loan)
  end

  context 'as creator' do
    let(:current_user) { creator }

    context 'for a published, but unconfirmed loan' do
      let(:loan_amount) { 40.00 }

      before do
        assign_activities
        render
      end

      it do
        expect(rendered).to \
          have_content('you submitted a loan to josh.schramm@gmail.com for ' \
                       '$40.00')
      end
    end

    context 'for a confirmed loan' do
      let(:loan_amount) { 9000.01 }

      before do
        ConfirmLoanParticipation.for(borrower, loan)
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
    end
  end

  context 'as participant' do
    let(:current_user) { borrower }
    let(:loan_amount) { 10 }
    let!(:payment) do
      CreatePayment.with(
        borrower,
        loan,
        FactoryGirl.attributes_for(:payment_form, amount: 1)
      ).payment
    end

    before do
      DisputeLoanParticipation.with(borrower, loan)
      ConfirmLoanParticipation.with(borrower, loan)
      ConfirmPaymentParticipation.with(borrower, payment)
      assign_activities
      render
    end

    it 'has creation item' do
      expect(rendered)
        .to have_content('Elliott Mason submitted a loan to you for $10.00')
    end

    it 'has confirmation item' do
      expect(rendered)
        .to have_content("you confirmed Elliott Mason's loan to you for $10.00")
    end

    it 'has dispute item' do
      expect(rendered)
        .to have_content("you disputed Elliott Mason's loan for $10.00")
    end

    it 'has payment item' do
      expect(rendered)
        .to have_content("you submitted a $1.00 payment toward Elliott " \
                         "Mason's loan for $10.00")
    end
  end
end
