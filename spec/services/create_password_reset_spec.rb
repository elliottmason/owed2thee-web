require 'rails_helper'

describe CreatePasswordReset do
  let(:email_address) { create(:email_address) }

  context 'successfully performed' do
    it 'cancels previous PasswordResets' do
      3.times { described_class.with(email_address) }
      expect(
        PasswordReset.
          where(email_address: email_address).
          in_redemption_state(:canceled).
          count
      ).to eq 2
      expect(
        PasswordReset.
          where(email_address: email_address).
          not_in_redemption_state(:canceled).
          count
      ).to eq 1
    end
  end
end
