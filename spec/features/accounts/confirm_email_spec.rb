feature 'Confirm email address', :devise, :js do
  let(:email_address) { user.email_addresses.first }
  let(:user)          { FactoryGirl.create(:unconfirmed_user) }

  let(:confirm_email_page)  { Accounts::Emails::ConfirmPage.new }
  let(:home_page)           { HomePage.new }

  let(:confirmation_message) do
  end

  def confirm_email_address(confirmation_token = nil)
    confirmation_token ||= email_address.confirmation_token
    confirm_email_page.load(
      confirmation_token: confirmation_token,
      email:              email_address.address
    )
  end

  context 'for user with existing activity' do
    let(:change_password_page) { Accounts::Passwords::EditPage.new }

    scenario 'with correct confirmation token' do
      confirm_email_address
      expect(change_password_page).to be_displayed
      expect(change_password_page).to have_content(confirmation_message)
    end
  end

  context 'for confirmed user' do
    let(:email_address) do
      FactoryGirl.create(:unconfirmed_email_address, user: user)
    end
    let(:user) { FactoryGirl.create(:confirmed_user) }

    let(:loans_page) { Loans::IndexPage.new }

    scenario 'with correct confirmation token' do
      confirm_email_address
      expect(loans_page).to be_displayed
      expect(loans_page).to have_content(confirmation_message)
    end
  end

  scenario 'with bad confirmation token' do
    confirm_email_address('wrongtoken')
    expect(home_page).to be_displayed
  end
end
