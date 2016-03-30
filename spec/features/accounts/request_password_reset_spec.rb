require 'rails_helper'

feature 'Requesting a reset for a forgotten password', :devise, :js do
  let(:email_address) { user.primary_email_address.address }
  let(:sent_email)    { ActionMailer::Base.deliveries[0] }
  let(:user) do
    FactoryGirl.create(:unconfirmed_user,
                       email_address: 'josh.schramm@gmail.com')
  end

  let(:forgot_password_page) { Accounts::Passwords::ForgotPage.new }
  let(:confirmation_page) { Accounts::Passwords::ForgotConfirmationPage.new }
  let(:sign_in_page) { SignInPage.new }

  before do
    ActionMailer::Base.deliveries.clear
  end

  context 'for a known email address' do
    before do
      sign_in_page.load
      sign_in_page.forgot_password_link.click
      expect(forgot_password_page).to be_displayed
      forgot_password_page.email_form.email_address_field.set(email_address)
      forgot_password_page.email_form.submit
    end

    scenario 'sends an email to reset the password' do
      expect(confirmation_page).to be_displayed
      expect(sent_email.to).to eq [email_address]
      expect(sent_email.subject).
        to eq '[Owed2Thee] - How to reset your password'
    end
  end

  context 'for unknown email address' do
    before do
      forgot_password_page.load
      forgot_password_page.email_form.email_address_field.set('fake@false.co')
      forgot_password_page.email_form.submit
    end

    scenario 'shows an error message' do
      expect(forgot_password_page).to be_displayed
      expect(forgot_password_page.email_form).to be_visible
      expect(ActionMailer::Base.deliveries.size).to be_zero
    end
  end
end
