require 'rails_helper'

describe Users::SessionsController do
  describe 'GET create' do
    def make_request(confirmation_token = nil)
      get(:create,
          confirmation_token: confirmation_token || self.confirmation_token)
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
          make_request
          expect(response).to redirect_to(edit_user_password_path)
        end
      end

      context 'with unknown confirmation token' do
        it 'with expired confirmation token' do
          make_request('asdf')
          expect(response).to redirect_to(new_user_session_path)
        end
      end

      context 'with expired confirmation token' do
        it 'redirects to signin page' do
          Timecop.travel(7.days.from_now)
          make_request
          expect(response).to redirect_to(new_user_session_path)
        end
      end

      context 'with redeemed confirmation token' do
        it 'redirects to signin page' do
          RedeemTemporarySignin.with(password_reset)
          make_request
          expect(response).to redirect_to(new_user_session_path)
        end
      end
    end
  end
end
