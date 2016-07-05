require 'rails_helper'

describe RobotsController do
  describe 'GET show' do
    context 'for HTML' do
      it do
        expect { get :show, format: 'html' }.
          to raise_exception(ActionController::UnknownFormat)
      end
    end

    context 'for TXT format' do
      before do
        get :show, format: 'txt'
      end

      it 'is successful' do
        expect(response).to be_successful
      end
    end
  end
end
