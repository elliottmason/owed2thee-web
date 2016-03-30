require 'rails_helper'

RSpec.describe do
  let(:confirmation_token) { '34PCNkrmp9ovPpWhn5fYf27DbxSjpsrB9QBMKwLTKug' }

  describe 'loans' do
    let(:uuid) { SecureRandom.uuid }

    it do
      expect(get: "/loans/#{uuid}").to route_to(
        action: 'show',
        controller: 'loans',
        uuid: uuid
      )
    end
  end

  describe 'email address confirmation' do
    it do
      expect(
        get: "/email_address/confirm/#{confirmation_token}"
      ).to route_to(
        action:     'create',
        controller: 'email_address_confirmations/redemptions',
        email_address_confirmation_confirmation_token: confirmation_token
      )
    end
  end
end
