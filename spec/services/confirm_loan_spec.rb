require 'spec_helper'

describe ConfirmLoan do
  let(:borrower)  { loan.borrower }
  let(:creator)   { loan.creator }
  let(:ledger)    { LedgerQuery.between!(*loan.participants) }
  let(:loan)      { FactoryGirl.create(:published_loan, amount: 20) }
  let(:service)   { described_class.new(loan, creator) }

  before do
    FactoryGirl.create(:confirmed_loan, borrower: borrower,
                                        creator:  creator,
                                        amount:   10)
  end

  describe '#perform' do
    before do
      service.perform
    end

    context 'successful' do
      it 'calculates the confirmed balance between borrower and lender' do
        expect(ledger.confirmed_balance_for(loan.lender).to_i).to eq(-30)
        expect(ledger.confirmed_balance_for(loan.borrower).to_i).to eq(30)
      end

      it 'calculates the projected balance between borrower and lender' do
        expect(ledger.projected_balance_for(loan.lender).to_i).to eq(-30)
        expect(ledger.projected_balance_for(loan.borrower).to_i).to eq(30)
      end
    end
  end
end
