require 'rails_helper'

RSpec.describe Ledger, type: :model do
  context 'users are identical' do
    let(:ledger)  { FactoryGirl.build(:ledger, user_a: user, user_b: user) }
    let(:user)    { FactoryGirl.create(:user, :with_email) }

    it { expect(ledger).to be_invalid }
  end

  context 'opposite user order exists' do
    let(:ledger_a) { FactoryGirl.create(:ledger) }
    let(:ledger_b) do
      FactoryGirl.build(:ledger, user_a: ledger_a.user_b,
                                 user_b: ledger_a.user_a)
    end

    it { expect(ledger_b).to be_invalid }
  end
end
