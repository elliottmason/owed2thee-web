require 'rails_helper'

describe 'routes', :routing do
  let(:confirmation_token) { '34PCNkrmp9ovPpWhn5fYf27DbxSjpsrB9QBMKwLTKug' }

  describe 'loans' do
    let(:uuid) { '92b0c876-8a6d-4979-af98-67d0c7aeda85' }

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

    describe 'comments' do
      pending do
        expect(post: "loans/#{uuid}/comments").to route_to(
          action:     'create',
          controller: 'loans/comments',
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
