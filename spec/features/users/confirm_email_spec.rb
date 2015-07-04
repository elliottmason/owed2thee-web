feature 'Confirm email address', :devise, :js do
  let(:email_address) { user.email_addresses.first }
  let(:user) { FactoryGirl.create(:user_with_email) }

  let(:confirm_email_page)  { ConfirmEmailPage.new }
  let(:home_page)           { HomePage.new }

  scenario 'with correct confirmation token' do
    confirm_email_page.load(confirmation_token: email_address.confirmation_token,
                            email: email_address.address)
    expect(home_page).to be_displayed
  end

  scenario 'with incorrect confirmation token' do
    confirm_email_page.load(confirmation_token: 'abcd0123',
                            email: email_address.address)
  end
end
