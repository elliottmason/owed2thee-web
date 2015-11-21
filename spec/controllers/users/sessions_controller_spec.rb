require 'spec_helper'

describe Users::SessionsController do
  describe 'GET create' do
    def make_request
      get(:create, confirmation_token: confirmation_token)
    end

    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
    end

    context 'for PasswordReset' do
      let!(:confirmation_token) { password_reset.confirmation_token }
      let(:email_address)       { user.primary_email_address }
      let(:password_reset) do
        CreatePasswordReset.with(email_address).password_reset
      end
      let(:user) do
        FactoryGirl.create(:unconfirmed_user,
                           email_address: 'josh.schramm@gmail.com')
      end

      context 'with valid confirmation token' do
        it 'redirect to edit password page' do
          get :create, confirmation_token: confirmation_token

          expect(response).to redirect_to(edit_user_password_path)
        end
      end

      context 'with expired confirmation token' do
        it 'returns error response' do
          Timecop.travel(7.days.from_now)
          make_request
          expect(response.status).to eq 403
        end
      end

      context 'with redeemed confirmation token' do
        it 'returns error response' do
          RedeemTemporarySignin.with(password_reset)
          make_request
          expect(response.status).to eq 403
        end
      end
    end
  end
end
