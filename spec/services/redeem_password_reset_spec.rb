require 'rails_helper'

describe RedeemPasswordReset do
  let(:email_address) { FactoryGirl.create(:email_address) }
  let(:password_reset) { CreatePasswordReset.for(email_address).password_reset }
  let(:user) { email_address.user }

  context 'successful performance' do
    before do
      RedeemPasswordReset.with(password_reset)
    end

    context 'for unconfirmed email address' do
      it 'confirms the associated email address' do
        expect(email_address).to be_confirmed
      end
    end

    context 'for unconfirmed user' do
      it 'confirms the associated user' do
        expect(user).to be_confirmed
      end
    end
  end
end
