require 'rails_helper'

RSpec.describe 'users/show.html.slim' do
  include ApplicationHelper
  include UsersHelper

  let(:current_user) { FactoryGirl.create(:unconfirmed_user) }

  before do
    sign_in(current_user)
    assign(:user, target_user)
  end

  context 'with confirmed_user' do
    let!(:confirmed_loan) do
      FactoryGirl.create(:confirmed_loan, amount:   10,
                                          borrower: target_user,
                                          creator:  current_user)
    end
    let!(:confirmed_payment) do
      FactoryGirl.create(:confirmed_payment, amount:    5,
                                             creator:   target_user,
                                             payee:     current_user)
    end
    let!(:confirmed_debt) do
      FactoryGirl.create(:confirmed_loan, amount:   15,
                                          borrower: current_user,
                                          creator:  target_user)
    end
    let!(:unconfirmed_debt) do
      FactoryGirl.create(:unconfirmed_loan, amount:   25,
                                            borrower: current_user,
                                            creator:  target_user)
    end
    let(:target_user) do
      FactoryGirl.create(:unconfirmed_user, first_name: 'Kyle',
                                            last_name:  'Balderson')
    end

    before do
      render
    end

    it "shows user's full name" do
      expect(rendered).to have_content('Kyle Balderson')
    end

    it 'shows balance with user' do
      expect(rendered).to have_content('you owe $10.00')
    end

    it 'lists confirmed transfers' do
      expect(rendered).to \
        have_selector("tr#transfer_#{confirmed_loan.id}", text: 'borrowed')
      expect(rendered).to \
        have_selector("tr#transfer_#{confirmed_loan.id}", text: '$10.00')
      expect(rendered).to \
        have_selector("tr#transfer_#{confirmed_payment.id}", text: 'paid you')
      expect(rendered).to \
        have_selector("tr#transfer_#{confirmed_payment.id}", text: '$5.00')
      expect(rendered).to \
        have_selector("tr#transfer_#{confirmed_debt.id}", text: 'lent you')
      expect(rendered).to \
        have_selector("tr#transfer_#{confirmed_debt.id}", text: '$15.00')
    end

    it 'lists unconfirmed transfers' do
      expect(rendered).to \
        have_selector("tr#transfer_#{unconfirmed_debt.id}", text: 'lent you')
      expect(rendered).to \
        have_selector("tr#transfer_#{unconfirmed_debt.id}", text: '$25.00')
    end
  end

  context 'with unconfirmed contact' do
    let(:alternate_email) do
      FactoryGirl.create(:email_address,  address:  'kyle_2@example.com',
                                          user:     target_user)
    end
    let(:target_user) do
      FactoryGirl.create(:unconfirmed_user, email_address: 'kyle_1@example.com')
    end
    let!(:unconfirmed_loan) do
      FactoryGirl.create(:published_loan, contact_name: alternate_email.address,
                                          borrower:     target_user,
                                          creator:      current_user)
    end

    before do
      render
    end

    it 'shows email addressed used to contact user' do
      expect(rendered).to have_content('kyle_2@example.com')
    end
  end
end
