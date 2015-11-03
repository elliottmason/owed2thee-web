require 'spec_helper'

describe 'public_activity/loan/_created' do
  context 'as creator' do
    let(:activity) { loan.activities.where(recipient: loan.creator).first }
    let!(:borrower) do
      FactoryGirl.create(:confirmed_user,
                         email_address: borrower_email_address,
                         first_name: 'Josh',
                         last_name: 'Schramm')
    end
    let(:borrower_email_address) { 'josh.schramm@gmail.com' }
    let(:loan) do
      CreateLoan.with(FactoryGirl.create(:confirmed_user), loan_form).loan
    end
    let(:loan_form) do
      FactoryGirl.attributes_for(
        :loan_form,
        amount: loan_amount,
        obligor_email_address: borrower_email_address
      )
    end

    def render_partial
      render(partial: 'public_activity/loan/created',
             locals: { activity: activity })
    end

    before do
      RecordTransferActivity.for(loan, :created)
      sign_in(loan.creator)
    end

    context 'unconfirmed loan' do
      let(:loan_amount) { 40.00 }

      before do
        render_partial
      end

      it do
        expect(rendered).to \
          have_content('you submitted a loan: lent josh.schramm@gmail.com ' \
                        '$40.00')
      end
    end

    context 'confirmed loan' do
      let(:loan_amount) { 9000.01 }

      before do
        ConfirmLoan.with(loan)
      end

      it do
        render_partial

        expect(rendered)
          .to have_content('you submitted a loan: lent Josh Schramm $9000.01')
      end
    end
  end

  context 'as participant' do
    before do
      sign_in(loan.borrowers.first)
    end
  end
end
