require 'spec_helper'

describe PublishLoan do
  let(:borrower)  { loan.borrower }
  let(:creator)   { loan.creator }
  let(:ledger)    { LedgerQuery.between!(*loan.participants) }
  let(:loan)      { FactoryGirl.create(:unconfirmed_loan, amount: 20) }
  let(:service)   { PublishLoan.new(loan, creator) }

  describe '#perform' do
    context 'successful' do
      before do
        FactoryGirl.create(:confirmed_loan, borrower: borrower,
                                            creator: creator,
                                            amount: 10)
        service.perform
      end

      it 'calculates the confirmed balance between borrower and lender' do
        expect(ledger.confirmed_balance_for(loan.lender).to_i).to eq(-10)
        expect(ledger.confirmed_balance_for(loan.borrower).to_i).to eq(10)
      end

      it 'calculates the projected balance between borrower and lender' do
        expect(ledger.projected_balance_for(loan.lender).to_i).to eq(-30)
        expect(ledger.projected_balance_for(loan.borrower).to_i).to eq(30)
      end
    end
  end
end
