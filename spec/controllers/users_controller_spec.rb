require 'rails_helper'

RSpec.describe UsersController do
  describe 'GET show' do
    let(:current_user)  { FactoryGirl.create(:confirmed_user) }
    let(:target_user)   { FactoryGirl.create(:unconfirmed_user) }

    context 'signed in' do
      before do
        sign_in(current_user)
      end

      it 'is successful' do
        get :show, uuid: target_user.uuid
        expect(response).to be_successful
      end
    end
  end
end
