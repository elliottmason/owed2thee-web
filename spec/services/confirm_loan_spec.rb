require 'rails_helper'

describe ConfirmLoan do
  let(:borrower)  { loan.borrower }
  let(:creator)   { loan.creator }
  let(:ledger)    { LedgerQuery.first_between(*loan.participants) }
  let(:lender)    { loan.lender }
  let(:loan)      { FactoryGirl.create(:published_loan, amount: 20) }

  before do
    # extant confirmed loan to make balance calculations less straightforward
    FactoryGirl.create(:confirmed_loan, borrower: borrower,
                                        creator:  creator,
                                        amount:   10)
  end

  describe '.with' do
    before do
      described_class.with(loan, borrower)
    end

    context 'successful' do
      it 'calculates the confirmed balance between borrower and lender' do
        expect(ledger.confirmed_balance(lender).to_i).to eq(-30)
        expect(ledger.confirmed_balance(borrower).to_i).to eq(30)
      end

      it 'calculates the projected balance between borrower and lender' do
        expect(ledger.projected_balance(lender).to_i).to eq(-30)
        expect(ledger.projected_balance(borrower).to_i).to eq(30)
      end
    end
  end
end
