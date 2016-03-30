require 'rails_helper'

feature 'Confirm email address', :devise, :js do
  let(:confirmation_token) do
    create(:email_address_confirmation, email_address: email_address).
      confirmation_token
  end
  let(:email_address) { user.email_addresses.first }
  let(:user) do
    FactoryGirl.create(:unconfirmed_user,
                       email_address: 'josh.schramm@gmail.com')
  end

  let(:confirm_email_page) { Emails::ConfirmPage.new }

  let(:confirmation_message) do
    'You confirmed your email address: josh.schramm@gmail.com'
  end

  def confirm_email_address(confirmation_token = self.confirmation_token)
    confirm_email_page.load(confirmation_token: confirmation_token)
  end

  context 'for unconfirmed user' do
    let(:loans_page) { Loans::IndexPage.new }

    context 'with correct confirmation token' do
      scenario 'with correct confirmation token' do
        confirm_email_address
        expect(loans_page).to be_displayed
        expect(loans_page).to have_content(confirmation_message)
      end
    end

    context 'with exactly one unconfirmed debt' do
      let!(:loan) { create(:published_loan, borrower: user) }
      let(:loan_page) { Loans::ShowPage.new }

      context 'using correct confirmation token' do
        scenario 'redirects to debt' do
          confirm_email_address
          expect(loan_page).to be_displayed
          expect(loan_page).to have_content(confirmation_message)
        end
      end
    end
  end

  context 'for confirmed user' do
    let(:email_address) do
      FactoryGirl.create(:unconfirmed_email_address,
                         address: 'josh.schramm@gmail.com',
                         user: user)
    end
    let(:user) { FactoryGirl.create(:confirmed_user) }

    let(:loans_page) { Loans::IndexPage.new }

    before do
      confirm_email_address
    end

    scenario 'with correct confirmation token' do
      expect(loans_page).to be_displayed
      expect(loans_page).to have_content(confirmation_message)
    end
  end

  context 'with bad confirmation token' do
    let(:confirmation_token) { 'wrongtoken' }

    let(:sign_in_page) { SignInPage.new }

    before do
      confirm_email_address
    end

    scenario do
      expect(sign_in_page).to be_displayed
    end
  end
end
