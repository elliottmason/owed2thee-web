feature 'Confirm email address', :devise, :js do
  let(:confirmation_token)  { email_address.confirmation_token }
  let(:email_address)       { user.email_addresses.first }
  let(:user) do
    FactoryGirl.create(:unconfirmed_user,
                       email_address: 'josh.schramm@gmail.com')
  end

  let(:confirm_email_page)  { Accounts::Emails::ConfirmPage.new }
  let(:home_page)           { HomePage.new }

  let(:confirmation_message) do
    'You confirmed your email address: josh.schramm@gmail.com'
  end

  def confirm_email_address(confirmation_token = self.confirmation_token)
    confirm_email_page.load(
      confirmation_token: confirmation_token,
      email:              email_address.address
    )
  end

  context 'for unconfirmed user' do
    let(:change_password_page) { Accounts::Passwords::EditPage.new }

    scenario 'with correct confirmation token' do
      confirm_email_address
      expect(change_password_page).to be_displayed
      expect(change_password_page).to have_content(confirmation_message)
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

    before do
      confirm_email_address
    end

    scenario do
      expect(home_page).to be_displayed
    end
  end
end
