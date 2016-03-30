require 'spec_helper'

describe PublishLoan do
  let(:borrower)  { loan.borrower }
  let(:creator)   { loan.creator }
  let(:ledger)    { LedgerQuery.between!(*loan.participants) }
  let(:loan)      { FactoryGirl.create(:unpublished_loan, amount: 20) }
  let(:service)   { described_class.new(loan, creator) }

  before do
    FactoryGirl.create(:confirmed_loan, borrower: borrower,
                                        creator:  creator,
                                        amount:   10)
    ActionMailer::Base.deliveries.clear
  end

  describe '#perform' do
    before do
      service.perform
    end

    context 'successful' do
      it 'calculates the confirmed balance between borrower and lender' do
        expect(ledger.confirmed_balance(loan.lender).to_i).to eq(-10)
        expect(ledger.confirmed_balance(loan.borrower).to_i).to eq(10)
      end

      it 'calculates the projected balance between borrower and lender' do
        expect(ledger.projected_balance(loan.lender).to_i).to eq(-30)
        expect(ledger.projected_balance(loan.borrower).to_i).to eq(30)
      end

      it 'sends confirmation email to obligor' do
        expect(ActionMailer::Base.deliveries.size).to eq 1
        expect(ActionMailer::Base.deliveries[0].to).
          to eq [borrower.primary_email_address.address]
      end
    end
  end
end
