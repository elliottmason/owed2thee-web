require 'rails_helper'

feature 'Creating a loan request', :js do
  let(:show_loan_request_page)  { LoanRequests::ShowPage.new }
  let(:new_loan_request_page)   { LoanRequests::NewPage.new }
  let(:sign_in_page)            { SignInPage.new }

  context 'while not signed in' do
    before do
      new_loan_request_page.load
    end

    scenario 'redirects to the sign in page' do
      expect(sign_in_page).to be_displayed
    end
  end

  context 'while signed in as a confirmed user' do
    let(:user) { create(:confirmed_user) }

    before do
      login_as(user)
      new_loan_request_page.load
    end

    context 'with no amount' do
      before do
        new_loan_request_page.loan_request_form.submit({})
      end

      scenario 'displays an error message' do
        expect(new_loan_request_page)
          .to have_content I18n.t('loan_requests.errors.creation')
      end
    end

    context 'with an amount and no deadlines' do
      before do
        new_loan_request_page.loan_request_form.submit(
          amount_requested: '100.00'
        )
      end

      scenario 'shows the newly created request' do
        expect(show_loan_request_page).to be_displayed
      end
    end
  end
end
