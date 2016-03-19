require 'spec_helper'

describe ConfirmPayment do
  let(:ledger)    { LedgerQuery.between!(*payment.participants) }
  let(:payee)     { payment.payee }
  let(:payer)     { payment.payer }
  let(:payment)   { create(:unconfirmed_payment, amount: 3) }
  let(:service)   { described_class.new(payment, payer) }

  before do
    FactoryGirl.create(:confirmed_loan, borrower: payer,
                                        creator:  payee,
                                        amount:   10)
    FactoryGirl.create(:confirmed_loan, borrower: payee,
                                        creator:  payer,
                                        amount:   5)
  end

  describe '#perform' do
    before do
      service.perform
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
    end
  end
end
