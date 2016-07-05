require 'rails_helper'

describe 'routes', :routing do
  describe 'email address confirmation' do
    let(:confirmation_token) { '34PCNkrmp9ovPpWhn5fYf27DbxSjpsrB9QBMKwLTKug' }

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

  describe 'loans' do
    let(:uuid) { '92b0c876-8a6d-4979-af98-67d0c7aeda85' }

    pending do
      expect(post: '/loans').to route_to(
        action:     'create',
        controller: 'loans'
      )
    end

    it do
      expect(get: "/loans/#{uuid}").to route_to(
        action:     'show',
        controller: 'loans',
        uuid:       uuid
      )
    end

    it do
      %i(patch put).each do |verb|
        expect(verb => "/loans/#{uuid}/cancel").to route_to(
          action:     'cancel',
          controller: 'loans',
          uuid:       uuid
        )
      end
    end

    it do
      %i(patch put).each do |verb|
        expect(verb => "/loans/#{uuid}/confirm").to route_to(
          action:     'confirm',
          controller: 'loans',
          uuid:       uuid
        )
      end
    end

    it do
      %i(patch put).each do |verb|
        expect(verb => "/loans/#{uuid}/dispute").to route_to(
          action:     'dispute',
          controller: 'loans',
          uuid:       uuid
        )
      end
    end

    it do
      %i(patch put).each do |verb|
        expect(verb => "/loans/#{uuid}/publish").to route_to(
          action:     'publish',
          controller: 'loans',
          uuid:       uuid
        )
      end
    end

    describe 'descriptions' do
      pending do
        expect(post: "/loans/#{uuid}/descriptions").to route_to(
          action:     'create',
          controller: 'loans/descriptions',
          loan_uuid:  uuid
        )
      end
    end

    describe 'payments' do
      pending do
        expect(post: "loans/#{uuid}/payments").to route_to(
          action:     'create',
          controller: 'loans/payments',
          loan_uuid:  uuid
        )
      end

      pending do
        expect(get: "loans/#{uuid}/payments/new").to route_to(
          action:     'new',
          controller: 'loans/payments',
          loan_uuid:  uuid
        )
      end
    end
  end

  describe 'loan requests' do
    it do
      expect(post: '/loan_requests').to route_to(
        action:     'create',
        controller: 'loan_requests'
      )
    end
  end

  describe 'robots.txt' do
    it do
      expect(get: '/robots.txt').to route_to(
        action:     'show',
        controller: 'robots',
        format:     'txt'
      )
    end
  end
end
