require 'rails_helper'

describe PublishLoan, :background do
  let(:borrower)  { loan.borrower }
  let(:creator)   { loan.creator }
  let(:ledger)    { LedgerQuery.first_between(*loan.participants) }
  let(:lender)    { loan.lender }
  let(:loan)      { FactoryGirl.create(:unpublished_loan, amount: 20) }

  before do
    FactoryGirl.create(:confirmed_loan, borrower: borrower,
                                        creator:  creator,
                                        amount:   10)
    ActionMailer::Base.deliveries.clear
  end

  describe '.with' do
    before do
      perform_enqueued_jobs do
        described_class.with(loan, creator)
      end
    end

    context 'successful' do
      it 'calculates the confirmed balance between borrower and lender' do
        described_class.with(loan, creator)
        expect(ledger.confirmed_balance(lender).to_i).to eq(-10)
        expect(ledger.confirmed_balance(borrower).to_i).to eq(10)
      end

      it 'calculates the projected balance between borrower and lender' do
        described_class.with(loan, creator)
        expect(ledger.projected_balance(lender).to_i).to eq(-30)
        expect(ledger.projected_balance(borrower).to_i).to eq(30)
      end

      it 'sends confirmation email to obligor' do
        expect(ActionMailer::Base.deliveries.size).to eq 1
        expect(ActionMailer::Base.deliveries[0].to).
          to eq [borrower.primary_email_address.address]
      end
    end
  end
end
