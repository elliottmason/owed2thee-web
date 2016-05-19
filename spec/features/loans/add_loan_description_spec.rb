require 'rails_helper'

feature 'Adding a description to a loan', :js do
  let(:current_user) { loan.creator }
  let(:loan) { create(:unconfirmed_loan) }
  let(:loan_description) { 'You asked for some brews, and I came through' }

  let(:loan_page) { Loans::ShowPage.new }

  before do
    login_as(current_user)
    loan_page.load(uuid: loan.uuid)
  end

  context 'with valid content' do
    before do
      loan_page.submit_description(loan_description)
    end

    scenario 'displays submitted description' do
      expect(loan_page).to be_displayed
      expect(loan_page).to have_content(loan_description)
    end

    scenario 'hides the description form' do
      expect(loan_page).to have_no_description_form
    end
  end

  context 'with no content' do
    before do
      loan_page.submit_description('')
    end

    scenario 're-renders the description form' do
      expect(loan_page).to_not be_displayed
      expect(loan_page).to have_description_form
    end
  end
end
