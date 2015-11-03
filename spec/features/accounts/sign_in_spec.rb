feature 'Sign in', :devise, :js do
  let(:sign_in_page) { SignInPage.new }

  let(:user) { FactoryGirl.create(:confirmed_user) }

  scenario 'when unregistered' do
    sign_in_page.load
    sign_in_page.sign_in_form.submit(
      email:    Faker::Internet.email,
      password: Faker::Internet.password
    )
    expect(sign_in_page).to be_displayed
    expect(sign_in_page).to have_content(
      I18n.t('devise.failure.not_found_in_database',
             authentication_keys: 'email')
    )
  end

  scenario 'with valid credentials' do
    sign_in_page.load
    sign_in_page.sign_in_form.submit(
      email:    user.primary_email_address.address,
      password: user.password
    )
    expect(sign_in_page).to have_content I18n.t('devise.sessions.signed_in')
  end

  scenario 'with wrong email' do
    sign_in_page.load
    sign_in_page.sign_in_form.submit(
      email:    Faker::Internet.email,
      password: user.password
    )
    expect(page).to have_content(
      I18n.t('devise.failure.not_found_in_database',
             authentication_keys: 'email')
    )
  end

  scenario 'with wrong password' do
    sign_in_page.load
    sign_in_page.sign_in_form.submit(
      email:    user.primary_email_address.address,
      password: Faker::Internet.password
    )
    expect(page).to have_content(
      I18n.t('devise.failure.not_found_in_database',
             authentication_keys: 'email')
    )
  end
end
