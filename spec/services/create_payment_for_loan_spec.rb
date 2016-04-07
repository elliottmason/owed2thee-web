require 'rails_helper'

RSpec.describe CreatePaymentForLoan do
  let(:loan)    { create(:confirmed_loan) }
  let(:params)  { { amount: 10 } }
  let(:payee)   { loan.lender }
  let(:payer)   { loan.borrower }
  let(:service) { described_class.with(payer, loan, params) }

  describe '.with' do
    context 'payer is lender' do
      let(:payer) { loan.lender }

      it 'is unsuccessful' do
        expect(service).to_not be_successful
      end
    end

    context 'with invalid params' do
      let(:params) { { amount: -1.50 } }

      it 'is unsuccessful' do
        expect(service).to_not be_successful
      end
    end
  end
end
