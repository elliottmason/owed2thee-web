require 'rails_helper'

feature 'Signing in', :devise, :js do
  let(:sign_in_page) { SignInPage.new }

  let(:user) { FactoryGirl.create(:confirmed_user) }

  before do
    sign_in_page.load
  end

  context 'when unregistered' do
    before do
      sign_in_page.sign_in_form.submit(
        email:    Faker::Internet.email,
        password: Faker::Internet.password
      )
    end

    scenario 'redisplays the sign-in form' do
      expect(sign_in_page).to be_displayed
    end

    scenario 'shows an error message' do
      expect(sign_in_page).to have_content(
        I18n.t('devise.failure.not_found_in_database',
               authentication_keys: 'email')
      )
    end
  end

  context 'with valid credentials' do
    before do
      sign_in_page.sign_in_form.submit(
        email:    user.primary_email_address.address,
        password: user.password
      )
    end

    scenario do
      expect(sign_in_page).to have_content I18n.t('devise.sessions.signed_in')
    end
  end

  context 'with wrong email' do
    before do
      sign_in_page.sign_in_form.submit(
        email:    Faker::Internet.email,
        password: user.password
      )
    end

    scenario do
      expect(page).to have_content(
        I18n.t('devise.failure.not_found_in_database',
               authentication_keys: 'email')
      )
    end
  end

  context 'with wrong password' do
    before do
      sign_in_page.sign_in_form.submit(
        email:    user.primary_email_address.address,
        password: Faker::Internet.password
      )
    end

    scenario do
      expect(page).to have_content(
        I18n.t('devise.failure.not_found_in_database',
               authentication_keys: 'email')
      )
    end
  end
end
