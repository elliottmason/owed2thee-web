require 'rails_helper'

RSpec.describe VisitorsController do
  it 'is successful' do
    get :index
    expect(response).to be_successful
  end
end
