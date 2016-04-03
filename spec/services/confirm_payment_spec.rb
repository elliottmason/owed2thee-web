require 'rails_helper'

describe ConfirmPayment do
  let(:ledger)  { LedgerQuery.first_between(*payment.participants) }
  let(:payee)   { loan.lender }
  let(:payer)   { loan.borrower }
  let!(:loan)   { create(:confirmed_loan, amount: 10) }
  let(:payment) do
    create(:unconfirmed_payment, amount:  3,
                                 loan:    loan,
                                 payee:   payee,
                                 payer:   payer)
  end

  before do
    create(:confirmed_loan, borrower: payee,
                            creator:  payer,
                            amount:   5)
  end

  describe '.with' do
    before do
      described_class.with(payment, payee)
    end

    context 'successful' do
      it 'calculates the confirmed balance between payer and payee' do
        expect(ledger.confirmed_balance(payee).to_i).to eq(-2)
        expect(ledger.confirmed_balance(payer).to_i).to eq(2)
      end

      it 'calculates the projected balance between payer and payee' do
        expect(ledger.projected_balance(payee).to_i).to eq(-2)
        expect(ledger.projected_balance(payer).to_i).to eq(2)
      end

      it 'calculates the loan balance' do
        expect(loan.reload.balance.to_i).to eq(7)
      end

      it 'calculates the payment balance' do
        expect(payment.balance.to_i).to eq(0)
      end
    end
  end
end
